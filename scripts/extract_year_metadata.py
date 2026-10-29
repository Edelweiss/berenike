#!/usr/bin/env python3
"""
Extract year metadata from image directory paths and filenames.
Processes image_list.csv and adds a 'year' column based on folder and filename patterns.
"""

import pandas as pd
import re
import sys
from pathlib import Path

def normalize_year(year_str):
    """
    Normalize 2-digit year to 4-digit year.
    Rules: 00-26 -> 2000-2026, 27-99 -> 1927-1999
    """
    if not year_str:
        return None
    
    year_int = int(year_str)
    
    if year_int <= 26:
        return 2000 + year_int
    else:
        return 1900 + year_int

def extract_year_from_path(path):
    """
    Extract year from directory path.
    Priority: Look for patterns like "BE YYYY", "BE YY", "ΒΕ YYYY", "ΒΕ YY"
    """
    if not path:
        return None
    
    # Pattern 1: "BE YYYY" (4-digit year after BE)
    match = re.search(r'(?:BE|ΒΕ)\s*(\d{4})(?:\D|$)', path, re.IGNORECASE)
    if match:
        year = int(match.group(1))
        # Validate that it's a reasonable year
        if 1900 <= year <= 2100:
            return year
    
    # Pattern 2: "BE YY" or "BEYY" (2-digit year after BE, with word boundaries or separators)
    match = re.search(r'(?:BE|ΒΕ)\s*(\d{2})(?:\D|$)', path, re.IGNORECASE)
    if match:
        year_str = match.group(1)
        normalized = normalize_year(year_str)
        if normalized:
            return normalized
    
    return None

def extract_year_from_filename(filename):
    """
    Extract year from filename.
    Priority: Look for patterns like "BE YYYY", "BE YY", "BEYY"
    """
    if not filename:
        return None
    
    # Pattern 1: "BE YYYY" (4-digit year after BE)
    match = re.search(r'(?:BE|ΒΕ)\s*(\d{4})(?:\D|$)', filename, re.IGNORECASE)
    if match:
        year = int(match.group(1))
        # Validate that it's a reasonable year
        if 1900 <= year <= 2100:
            return year
    
    # Pattern 2: "BE YY" or "BEYY" (2-digit year after BE)
    match = re.search(r'(?:BE|ΒΕ)[\s_-]*(\d{2})(?:\D|$)', filename, re.IGNORECASE)
    if match:
        year_str = match.group(1)
        normalized = normalize_year(year_str)
        if normalized:
            return normalized
    
    return None

def extract_year(row):
    """
    Extract year using priority rules:
    1. Try to extract from path
    2. If not found, try to extract from filename
    3. Return None if no valid year found
    """
    path = row.get('path', '')
    filename = row.get('filename', '')
    
    # Priority 1: Extract from path
    year = extract_year_from_path(path)
    if year is not None:
        return year
    
    # Priority 2: Extract from filename
    year = extract_year_from_filename(filename)
    if year is not None:
        return year
    
    # Fallback: No year found
    return None

def main():
    # Get the script directory
    script_dir = Path(__file__).parent.absolute()
    project_root = script_dir.parent
    data_dir = project_root / 'data'
    
    input_file = data_dir / 'image_list.csv'
    output_file = data_dir / 'image_list.csv'
    
    print(f"Script directory: {script_dir}")
    print(f"Data directory: {data_dir}")
    print(f"Reading {input_file}...")
    
    if not input_file.exists():
        print(f"Error: {input_file} not found!")
        sys.exit(1)
    
    df = pd.read_csv(input_file)
    
    print(f"Processing {len(df)} rows...")
    df['year'] = df.apply(extract_year, axis=1)
    
    # Convert year to Int64 (nullable integer type) to handle NaN
    df['year'] = df['year'].astype('Int64')
    
    print(f"Writing to {output_file}...")
    df.to_csv(output_file, index=False, quoting=1)  # quoting=1 is QUOTE_ALL
    
    # Print statistics
    year_found = df['year'].notna().sum()
    year_missing = df['year'].isna().sum()
    
    print(f"\nExtraction Summary:")
    print(f"  Total rows: {len(df)}")
    print(f"  Years found: {year_found}")
    print(f"  Years missing: {year_missing}")
    print(f"  Success rate: {year_found/len(df)*100:.2f}%")
    print(f"\nYear distribution:")
    print(df['year'].value_counts().sort_index())
    print(f"\nDone! Updated file saved to {output_file}")

if __name__ == '__main__':
    main()
