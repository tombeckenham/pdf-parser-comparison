# PDF Parser Comparison

This project compares different PDF parsing libraries for text extraction accuracy, including support for multipage PDFs.

## Libraries included:
1. PyPDF (Python)
2. PyMuPDF (Python)
3. PDF.js (TypeScript/Node.js using pdfjs-dist)
4. pdfplumber (Python)
5. pdfreader (TypeScript/Node.js)
6. PyPDF2 (Python)
7. pdfminer.six (Python)
8. pdf-parse-new (TypeScript/Node.js)
9. unpdf (TypeScript/Node.js)

## Usage:
For Python parsers, run:
python <parser_name>/<parser_name>_parser.py <pdf_file> [-j]

For TypeScript/Node.js parsers, run:
cd <parser_name> && npm run start -- <pdf_file> [-j]

The -j flag outputs the result in JSON format.

Examples:
python pypdf/pypdf_parser.py sample.pdf -j
cd pdfjs && npm run start -- ../sample.pdf -j

## Setup:
1. Ensure you have Python 3.7+ and Node.js 20.15+ installed.
2. For Python parsers: 
   - Activate the virtual environment: source .venv/bin/activate
   - Install dependencies: pip install -r requirements.txt
3. For TypeScript/Node.js parsers: npm install in the respective directories

## Multipage PDFs:
All parsers handle multipage PDFs and concatenate the text from all pages into a single output.
