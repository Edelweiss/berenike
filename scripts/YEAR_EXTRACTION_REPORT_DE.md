# Extraktion von Jahresmetadaten - Berenike-Bilddatensatz

## Zusammenfassung

**Skript:** `extract_year_metadata.py`  
**Ausführungsdatum:** 01.10.2026  
**Verarbeitete Datei:** `../data/image_list.csv`  

### Ergebnisse
- **Gesamtzahl Datensätze:** 125.839
- **Gefundene Jahre:** 115.604 (91,87%)
- **Fehlende Jahre:** 10.235 (8,13%)

### Verteilung der extrahierten Jahre
| Jahr | Anzahl  |
|------|---------|
| 1994 | 22      |
| 1995 | 246     |
| 1996 | 116     |
| 1997 | 36      |
| 1998 | 32      |
| 1999 | 6       |
| 2000 | 24      |
| 2001 | 6       |
| 2009 | 4.522   |
| 2010 | 758     |
| 2011 | 418     |
| 2012 | 914     |
| 2013 | 309     |
| 2014 | 1.519   |
| 2015 | 296     |
| 2016 | 2       |
| 2017 | 160     |
| 2018 | 4.376   |
| 2019 | 26.067  |
| 2020 | 7.314   |
| 2021 | 7       |
| 2022 | 19.638  |
| 2023 | 10.460  |
| 2024 | 8.796   |
| 2025 | 7.895   |
| 2026 | 21.665  |

---

## Python-Skript

### Datei: `extract_year_metadata.py`

Das Skript automatisiert die Extraktion von Jahren aus Mustern in Verzeichniswegen und Dateinamen.

#### Hauptfunktionen

**1. Extraktionsregeln (Prioritätsreihenfolge)**
   - **Ebene 1:** Sucht im Verzeichnispath nach Mustern wie:
     - `BE JJJJ` (z.B. `BE 2026`)
     - `BE JJ` oder `BEJJ` (z.B. `BE22` → 2022)
     - `ΒΕ JJJJ` (Unterstützung für griechische Zeichen)
     - `ΒΕ JJ`
   
   - **Ebene 2:** Sucht bei fehlenden Ergebnissen im Dateinamen nach ähnlichen Mustern
   
   - **Fallback:** Wenn kein Muster erkannt wird, bleibt die Spalte leer (`NaN`)

**2. Normalisierung von zweistelligen zu vierstelligen Jahren**
   ```
   00-26 → 2000-2026
   27-99 → 1927-1999
   ```
   - Beispiel: `09` → 2009, `22` → 2022, `99` → 1999

**3. Validierung von Jahren**
   - Jahre werden auf Gültigkeit im Bereich 1900-2100 überprüft
   - Stellt sicher, dass nur plausible Jahre beibehalten werden

#### Skriptstruktur

```python
def extract_year_from_path(path):
    """Extrahiert Jahr aus dem Verzeichnispath"""
    # Muster 1: "BE JJJJ"
    # Muster 2: "BE JJ" / "BEJJ"
    
def extract_year_from_filename(filename):
    """Extrahiert Jahr aus dem Dateinamen"""
    # Muster 1: "BE JJJJ"
    # Muster 2: "BE JJ"
    
def normalize_year(year_str):
    """Normalisiert 2-stellige zu 4-stelligen Jahren"""
    
def extract_year(row):
    """Wendet Prioritätsregeln an"""
    # 1. Versucht, aus dem Path zu extrahieren
    # 2. Versucht, aus dem Dateinamen zu extrahieren
    # 3. Gibt None zurück, wenn nichts gefunden wurde
```

#### Verwendete Regex-Muster

| Muster | Regulärer Ausdruck | Beschreibung |
|--------|------------------|-----------|
| BE + 4 Ziffern | `(?:BE\|ΒΕ)\s*(\d{4})` | Sucht nach "BE" gefolgt von 4 Ziffern |
| BE + 2 Ziffern | `(?:BE\|ΒΕ)[\s_-]*(\d{2})` | Sucht nach "BE" gefolgt von 2 Ziffern |

---

## Extraktionsbeispiele

### Erfolgreiche Extraktionen

#### Muster 1: Verzeichnisname (4-stellig)
```
Path: /Volumes/sd22b005/Berenike/Berenike/BE 2026/...
Ergebnis: 2026
```

#### Muster 2: Verzeichnisname (2-stellig)
```
Path: /Volumes/sd22b005/Berenike/Berenike/BE Steves_Photos_sorted/BE 22 Temple_courtyard_finals/...
Ergebnis: 2022
```

#### Muster 3: Dateiname (2-stellig)
```
Datei: 57011-BE09_0014-A-014_a.JPG
Ergebnis: 2009
```

#### Muster 4: Griechische Zeichen
```
Path: /Volumes/sd22b005/Berenike/Berenike/ΒΕ19 Trench Data/...
Ergebnis: 2019
```

#### Muster 5: Sikait (2-stellig im Path)
```
Path: /Volumes/sd22b005/Berenike/Berenike/Sikait 2025/...
Ergebnis: 2025
```

### Fälle, in denen das Jahr fehlt
```
Datei: DSC_0226.JPG
Path: /Volumes/sd22b005/Berenike/Berenike/Sikait 2025/Ostraca/SKP 25 M232_001_022/
Ergebnis: (leer) - BE/ΒΕ-Muster wurde nirgends gefunden
```

> Hinweis: Einige Dateien folgen nicht dem Muster BE/ΒΕ und haben keine Jahresmetadaten im Namen. In diesen Fällen kann das Änderungsdatum der Datei als alternativer Fallback verwendet werden.

---

## Verwendung des Skripts

### Installation von Abhängigkeiten
```bash
pip3 install pandas
```

### Ausführung

Aus dem Projektverzeichnis:
```bash
python3 scripts/extract_year_metadata.py
```

Oder direkt vom `scripts`-Verzeichnis:
```bash
cd scripts
python3 extract_year_metadata.py
```

### Ausgabe
- Die ursprüngliche CSV-Datei (`../data/image_list.csv`) wird mit der neuen Spalte `year` überschrieben
- Eine Zusammenfassung der Statistiken wird in der Konsole angezeigt
- Das Skript prüft automatisch, ob die Eingabedatei existiert

### Pfadstruktur
Das Skript verwendet relative Pfade, die sich automatisch an die Position anpassen:
```
berenike/
├── scripts/
│   └── extract_year_metadata.py  (Skript läuft von hier)
├── data/
│   └── image_list.csv            (Eingabe- und Ausgabedatei)
```

---

## Struktur der resultierenden CSV

### Davor
```csv
path,filename,file
"/Volumes/sd22b005/Berenike/Berenike/Temple Roof","BE22_Isis Temple_2022_02_18-roofing.jpg","/Volumes/sd22b005/Berenike/Berenike/Temple Roof/BE22_Isis Temple_2022_02_18-roofing.jpg"
```

### Danach
```csv
path,filename,file,year
"/Volumes/sd22b005/Berenike/Berenike/Temple Roof","BE22_Isis Temple_2022_02_18-roofing.jpg","/Volumes/sd22b005/Berenike/Berenike/Temple Roof/BE22_Isis Temple_2022_02_18-roofing.jpg",2022
```

---

## Datenanalyse

### Datenabdeckung
- **91,87%** der Bilder wurden einem Jahr zugeordnet
- **8,13%** der Bilder haben kein erkennbares Jahrmuster

### Zeiträume mit der höchsten Abdeckung
- **2019:** 26.067 Bilder (höchstes Volumen)
- **2026:** 21.665 Bilder (kürzliche Kampagne)
- **2022:** 19.638 Bilder
- **2023:** 10.460 Bilder
- **2024:** 8.796 Bilder

### Geschichte
- Datensätze reichen bis 1994 zurück
- Zeitraum der kontinuierlichen Abdeckung ab 2009
- Aktivitätsspitze: 2019-2026 (intensivste Grabungskampagnen)

---

## Nächste Schritte (Empfehlungen)

1. **Manuelle Validierung:** Überprüfung von Fällen, in denen das Jahr nicht extrahiert wurde
2. **Datums-Fallback:** Für Bilder ohne BE/ΒΕ-Muster sollte `exiftool` verwendet werden, um EXIF-Datum zu extrahieren
3. **Datenbankintegration:** Aktualisierte Daten in das Katalogisierungssystem importieren
4. **Zeitliche Analyse:** Spalte `year` für Analysen nach Grabungsperiode verwenden

---

## Technische Hinweise

- **Zeichenkodierung:** UTF-8 mit Unterstützung für griechische Zeichen
- **Datentyp:** Int64 (ganzzahliger Nullwert) zur Unterstützung von NaN-Werten
- **Zitierweise:** QUOTE_ALL für maximale Kompatibilität
- **Verarbeitung:** ~1,2 Minuten für 125.839 Datensätze
- **Pfaderkennung:** Das Skript erkennt automatisch seine Position und passt die Pfade relativ dazu an

