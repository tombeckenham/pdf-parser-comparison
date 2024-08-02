#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <path_to_pdf_file>"
    exit 1
fi

PDF_FILE="$1"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
RESULTS_DIR="$SCRIPT_DIR/parser_results"

mkdir -p "$RESULTS_DIR"

run_parser() {
    PARSER_NAME="$1"
    COMMAND="$2"
    
    echo "Running $PARSER_NAME..."
    
    $COMMAND "$PDF_FILE" > "$RESULTS_DIR/${PARSER_NAME}_output.txt"
    $COMMAND "$PDF_FILE" -j > "$RESULTS_DIR/${PARSER_NAME}_output.json"
    
    echo "$PARSER_NAME complete."
}

# Activate virtual environment
source "$SCRIPT_DIR/.venv/bin/activate"

# Run Python-based parsers
run_parser "pypdf" "python $SCRIPT_DIR/pypdf/pypdf_parser.py"
run_parser "pymupdf" "python $SCRIPT_DIR/pymupdf/pymupdf_parser.py"
run_parser "pdfplumber" "python $SCRIPT_DIR/pdfplumber/pdfplumber_parser.py"
run_parser "pypdf2" "python $SCRIPT_DIR/pypdf2/pypdf2_parser.py"
run_parser "pdfminer" "python $SCRIPT_DIR/pdfminer/pdfminer_parser.py"

# Deactivate virtual environment
deactivate

# Run TypeScript/Node.js-based parsers
cd "$SCRIPT_DIR/pdfjs"
run_parser "pdfjs" "npm run start --"
cd "$SCRIPT_DIR"

cd "$SCRIPT_DIR/pdfreader"
run_parser "pdfreader" "npm run start --"
cd "$SCRIPT_DIR"

cd "$SCRIPT_DIR/pdf-parse-new"
run_parser "pdf-parse-new" "npm run start --"
cd "$SCRIPT_DIR"

echo "All parsing complete. Results are in the '$RESULTS_DIR' directory."
