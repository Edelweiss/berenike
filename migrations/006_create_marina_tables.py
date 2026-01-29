#!/usr/bin/env python3
"""
Script to create marina, marina_updated, and iwona_unmerged tables from FileMaker XML exports
and populate them with data.
"""

import xml.etree.ElementTree as ET
import mysql.connector
from datetime import datetime
import re


def clean_xml_content(content):
    """Remove invalid XML characters from content."""
    # XML 1.0 legal characters:
    # #x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD] | [#x10000-#x10FFFF]
    # Remove control characters except tab, newline, carriage return
    def valid_xml_char(c):
        codepoint = ord(c)
        return (
            codepoint == 0x9 or
            codepoint == 0xA or
            codepoint == 0xD or
            (0x20 <= codepoint <= 0xD7FF) or
            (0xE000 <= codepoint <= 0xFFFD) or
            (0x10000 <= codepoint <= 0x10FFFF)
        )
    
    return ''.join(c for c in content if valid_xml_char(c))

# Database connection settings
DB_CONFIG = {
    'host': 'localhost',
    'user': 'berenike',
    'password': 'papy',
    'database': 'berenike',
    'charset': 'utf8mb4'
}

# Base path for XML files
XML_BASE_PATH = '/Users/elemmire/Papy_HCCH/projects/berenike/data/filemaker'

# XML file configurations - all have the same structure
XML_FILES = {
    'marina': 'Marina_FindBucketLocusTrench.xml',
    'marina_updated': 'Marina_updated_FindBucketLocusTrench.xml',
    'iwona_unmerged': 'Iwona_Unmerged_FindBucketLocusTrench.xml'
}


def get_field_names_from_xml(xml_path):
    """Extract field names from FileMaker XML file."""
    # Read and clean the XML content
    with open(xml_path, 'r', encoding='utf-8', errors='replace') as f:
        content = f.read()
    content = clean_xml_content(content)
    
    root = ET.fromstring(content)
    
    # FileMaker XML namespace
    ns = {'fm': 'http://www.filemaker.com/fmpxmlresult'}
    
    fields = []
    metadata = root.find('.//fm:METADATA', ns)
    if metadata is None:
        # Try without namespace
        metadata = root.find('.//METADATA')
    
    if metadata is not None:
        field_elements = metadata.findall('.//fm:FIELD', ns)
        if not field_elements:
            field_elements = metadata.findall('.//FIELD')
        for field in field_elements:
            name = field.get('NAME')
            if name:
                fields.append(name)
    
    return fields


def sanitize_column_name(field_name):
    """Convert FileMaker field name to valid SQL column name."""
    # Replace :: with underscore (for related field names like Loci::Season_Id)
    name = field_name.replace('::', '_')
    # Replace spaces with underscores
    name = name.replace(' ', '_')
    # Remove any other non-alphanumeric characters except underscore
    name = re.sub(r'[^a-zA-Z0-9_]', '', name)
    # Ensure it starts with a letter or underscore
    if name and name[0].isdigit():
        name = '_' + name
    return name.lower()


def parse_timestamp(value):
    """Parse FileMaker timestamp format to MySQL datetime."""
    if not value or value.strip() == '':
        return None
    
    # Try different formats
    formats = [
        '%d.%m.%Y %H:%M:%S',  # European format: 05.02.2025 11:05:17
        '%Y-%m-%d %H:%M:%S',  # ISO format
        '%Y-%m-%d',           # Date only
        '%d.%m.%Y',           # European date only
    ]
    
    for fmt in formats:
        try:
            return datetime.strptime(value.strip(), fmt)
        except ValueError:
            continue
    
    return None


def parse_int(value):
    """Parse integer value, return None if empty or invalid."""
    if not value or value.strip() == '':
        return None
    try:
        return int(float(value.strip()))
    except (ValueError, TypeError):
        return None


def create_table_sql(table_name, field_names):
    """Generate CREATE TABLE SQL statement."""
    columns = []
    
    for field_name in field_names:
        col_name = sanitize_column_name(field_name)
        
        # Determine column type based on field name
        if col_name == 'id' or col_name == 'pb_id':
            col_type = 'INT'
        elif col_name in ('created', 'modified'):
            col_type = 'TIMESTAMP NULL'
        else:
            col_type = 'TEXT'  # Use TEXT to avoid row size limits
        
        columns.append(f"    `{col_name}` {col_type}")
    
    columns_sql = ',\n'.join(columns)
    
    return f"""CREATE TABLE IF NOT EXISTS `{table_name}` (
{columns_sql},
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"""


def parse_xml_rows(xml_path, field_names):
    """Parse XML file and yield rows of data."""
    # Read and clean the XML content
    with open(xml_path, 'r', encoding='utf-8', errors='replace') as f:
        content = f.read()
    content = clean_xml_content(content)
    
    root = ET.fromstring(content)
    
    # FileMaker XML namespace
    ns = {'fm': 'http://www.filemaker.com/fmpxmlresult'}
    
    resultset = root.find('.//fm:RESULTSET', ns)
    if resultset is None:
        resultset = root.find('.//RESULTSET')
    
    if resultset is None:
        print(f"Warning: No RESULTSET found in {xml_path}")
        return
    
    rows = resultset.findall('.//fm:ROW', ns)
    if not rows:
        rows = resultset.findall('.//ROW')
    
    for row in rows:
        cols = row.findall('.//fm:COL', ns)
        if not cols:
            cols = row.findall('.//COL')
        row_data = []
        
        for i, col in enumerate(cols):
            data_elem = col.find('.//fm:DATA', ns)
            if data_elem is None:
                data_elem = col.find('.//DATA')
            value = data_elem.text if data_elem is not None else None
            
            if i < len(field_names):
                col_name = sanitize_column_name(field_names[i])
                
                # Convert value based on column type
                if col_name == 'id' or col_name == 'pb_id':
                    value = parse_int(value)
                elif col_name in ('created', 'modified'):
                    value = parse_timestamp(value)
                else:
                    # Keep as string, handle empty
                    if value is not None:
                        value = value.strip() if value.strip() else None
            
            row_data.append(value)
        
        yield row_data


def create_and_populate_table(cursor, table_name, xml_path):
    """Create table and insert data from XML file."""
    print(f"\nProcessing {table_name} from {xml_path}...")
    
    # Get field names
    field_names = get_field_names_from_xml(xml_path)
    print(f"  Found {len(field_names)} fields")
    
    # Drop existing table
    cursor.execute(f"DROP TABLE IF EXISTS `{table_name}`")
    print(f"  Dropped existing table if any")
    
    # Create table
    create_sql = create_table_sql(table_name, field_names)
    cursor.execute(create_sql)
    print(f"  Created table {table_name}")
    
    # Prepare insert statement
    col_names = [sanitize_column_name(f) for f in field_names]
    placeholders = ', '.join(['%s'] * len(col_names))
    columns_quoted = ', '.join([f'`{c}`' for c in col_names])
    insert_sql = f"INSERT INTO `{table_name}` ({columns_quoted}) VALUES ({placeholders})"
    
    # Insert rows
    row_count = 0
    skipped_count = 0
    batch = []
    batch_size = 1000
    
    # Find the index of the 'id' column
    id_col_index = None
    for i, fname in enumerate(field_names):
        if sanitize_column_name(fname) == 'id':
            id_col_index = i
            break

    for row_data in parse_xml_rows(xml_path, field_names):
        # Pad row if necessary
        while len(row_data) < len(col_names):
            row_data.append(None)
        # Truncate if too long
        row_data = row_data[:len(col_names)]
        
        # Skip rows where id is NULL
        if id_col_index is not None and row_data[id_col_index] is None:
            skipped_count += 1
            continue
        
        batch.append(tuple(row_data))
        
        if len(batch) >= batch_size:
            try:
                cursor.executemany(insert_sql, batch)
                row_count += len(batch)
                print(f"    Inserted {row_count} rows...", end='\r')
            except mysql.connector.Error as e:
                print(f"\n  Error inserting batch: {e}")
                # Try inserting one by one to find problematic row
                for single_row in batch:
                    try:
                        cursor.execute(insert_sql, single_row)
                        row_count += 1
                    except mysql.connector.Error as e2:
                        print(f"\n  Error inserting row: {e2}")
            batch = []
    
    # Insert remaining rows
    if batch:
        try:
            cursor.executemany(insert_sql, batch)
            row_count += len(batch)
        except mysql.connector.Error as e:
            print(f"\n  Error inserting final batch: {e}")
            for single_row in batch:
                try:
                    cursor.execute(insert_sql, single_row)
                    row_count += 1
                except mysql.connector.Error as e2:
                    print(f"\n  Error inserting row: {e2}")
    
    print(f"  Inserted {row_count} rows into {table_name} (skipped {skipped_count} empty rows)")
    return row_count


def main():
    """Main function to create tables and import data."""
    print("Connecting to database...")
    
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        print("Connected successfully!")
        
        total_rows = 0
        
        for table_name, xml_file in XML_FILES.items():
            xml_path = f"{XML_BASE_PATH}/{xml_file}"
            try:
                rows = create_and_populate_table(cursor, table_name, xml_path)
                total_rows += rows
                conn.commit()
            except Exception as e:
                print(f"Error processing {table_name}: {e}")
                conn.rollback()
                raise
        
        print(f"\n\nCompleted! Total rows inserted: {total_rows}")
        
        # Show table summaries
        print("\nTable summaries:")
        for table_name in XML_FILES.keys():
            cursor.execute(f"SELECT COUNT(*) FROM `{table_name}`")
            count = cursor.fetchone()[0]
            print(f"  {table_name}: {count} rows")
        
    except mysql.connector.Error as e:
        print(f"Database error: {e}")
        raise
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'conn' in locals():
            conn.close()
            print("\nDatabase connection closed.")


if __name__ == '__main__':
    main()
