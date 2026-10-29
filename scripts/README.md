# Scripts Verzeichnis

Dieses Verzeichnis enthält Python-Skripte für die Berenike-Projektdatenverarbeitung.

## Verfügbare Skripte

### `extract_year_metadata.py`

Automatisierte Extraktion von Jahresmetadaten aus Bild-Verzeichniswegen und Dateinamen.

**Zweck:** Verarbeitet `../data/image_list.csv` und fügt eine `year`-Spalte basierend auf BE/ΒΕ-Mustern hinzu.

**Verwendung:**
```bash
# Aus dem Projektverzeichnis
python3 scripts/extract_year_metadata.py

# Direkt aus dem scripts-Verzeichnis
cd scripts
python3 extract_year_metadata.py
```

**Abhängigkeiten:**
```bash
pip3 install pandas
```

**Ausgabe:**
- Aktualisierte CSV-Datei mit neuer `year`-Spalte in `../data/image_list.csv`
- Statistische Zusammenfassung in der Konsole

**Details:** Siehe [YEAR_EXTRACTION_REPORT_DE.md](./YEAR_EXTRACTION_REPORT_DE.md)

---

## Verzeichnisstruktur

```
berenike/
├── scripts/                          (dieses Verzeichnis)
│   ├── extract_year_metadata.py
│   ├── YEAR_EXTRACTION_REPORT_DE.md
│   └── README.md
├── data/                             (Eingabe- und Ausgabedaten)
│   └── image_list.csv
└── ...
```

## Hinweise

- Alle Skripte verwenden relative Pfade, die sich automatisch an die Position anpassen
- Skripte müssen mindestens Python 3.6+ haben
- Fehlerhafte Pfade werden automatisch geprüft und gemeldet

