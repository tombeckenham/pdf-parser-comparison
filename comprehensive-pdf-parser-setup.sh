#!/bin/bash

# Create virtual environment for Python parsers
python3 -m venv .venv
source .venv/bin/activate

# Install required Python libraries
pip install pypdf pymupdf pdfplumber PyPDF2 pdfminer.six

# Create directories for each parser
mkdir -p pypdf pymupdf pdfjs pdfplumber pdfreader pypdf2 pdfminer pdf-parse-new

# Create Python files for each parser
cat > pypdf/pypdf_parser.py << EOL
import sys
import json
from pypdf import PdfReader

def extract_text(pdf_path):
    reader = PdfReader(pdf_path)
    text = ''
    for page in reader.pages:
        text += page.extract_text() + '\n'
    return text.strip()

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Usage: python pypdf_parser.py <pdf_file> [-j]')
        sys.exit(1)

    pdf_path = sys.argv[1]
    json_output = '-j' in sys.argv

    text = extract_text(pdf_path)

    if json_output:
        print(json.dumps({'text': text}))
    else:
        print(text)
EOL

cat > pymupdf/pymupdf_parser.py << EOL
import sys
import json
import fitz

def extract_text(pdf_path):
    doc = fitz.open(pdf_path)
    text = ''
    for page in doc:
        text += page.get_text() + '\n'
    return text.strip()

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Usage: python pymupdf_parser.py <pdf_file> [-j]')
        sys.exit(1)

    pdf_path = sys.argv[1]
    json_output = '-j' in sys.argv

    text = extract_text(pdf_path)

    if json_output:
        print(json.dumps({'text': text}))
    else:
        print(text)
EOL

cat > pdfplumber/pdfplumber_parser.py << EOL
import sys
import json
import pdfplumber

def extract_text(pdf_path):
    with pdfplumber.open(pdf_path) as pdf:
        text = ''
        for page in pdf.pages:
            text += page.extract_text() + '\n'
    return text.strip()

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Usage: python pdfplumber_parser.py <pdf_file> [-j]')
        sys.exit(1)

    pdf_path = sys.argv[1]
    json_output = '-j' in sys.argv

    text = extract_text(pdf_path)

    if json_output:
        print(json.dumps({'text': text}))
    else:
        print(text)
EOL

cat > pypdf2/pypdf2_parser.py << EOL
import sys
import json
from PyPDF2 import PdfReader

def extract_text(pdf_path):
    reader = PdfReader(pdf_path)
    text = ''
    for page in reader.pages:
        text += page.extract_text() + '\n'
    return text.strip()

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Usage: python pypdf2_parser.py <pdf_file> [-j]')
        sys.exit(1)

    pdf_path = sys.argv[1]
    json_output = '-j' in sys.argv

    text = extract_text(pdf_path)

    if json_output:
        print(json.dumps({'text': text}))
    else:
        print(text)
EOL

cat > pdfminer/pdfminer_parser.py << EOL
import sys
import json
from io import StringIO
from pdfminer.high_level import extract_text_to_fp
from pdfminer.layout import LAParams

def extract_text(pdf_path):
    output_string = StringIO()
    with open(pdf_path, 'rb') as fin:
        extract_text_to_fp(fin, output_string, laparams=LAParams(), output_type='text', codec='utf-8')
    return output_string.getvalue().strip()

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Usage: python pdfminer_parser.py <pdf_file> [-j]')
        sys.exit(1)

    pdf_path = sys.argv[1]
    json_output = '-j' in sys.argv

    text = extract_text(pdf_path)

    if json_output:
        print(json.dumps({'text': text}))
    else:
        print(text)
EOL

# Create requirements.txt for Python libraries
cat > requirements.txt << EOL
pypdf
pymupdf
pdfplumber
PyPDF2
pdfminer.six
EOL

# Set up pdfjs (TypeScript/Node.js implementation using pdfjs-dist)
cd pdfjs
npm init -y
npm install pdfjs-dist @types/node typescript ts-node
npm pkg set type="module" scripts.build="tsc" scripts.start="node --experimental-specifier-resolution=node --loader ts-node/esm src/pdfjs_parser.ts"

cat > tsconfig.json << EOL
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "node",
    "esModuleInterop": true,
    "strict": true,
    "outDir": "./dist"
  },
  "include": ["src/**/*"],
  "ts-node": {
    "esm": true
  }
}
EOL

mkdir -p src
cat > src/pdfjs_parser.ts << EOL
import fs from 'fs';
import * as pdfjsLib from 'pdfjs-dist';

async function extractText(pdfPath: string): Promise<string> {
  const data = new Uint8Array(fs.readFileSync(pdfPath));
  const loadingTask = pdfjsLib.getDocument({ data });
  const doc = await loadingTask.promise;
  
  let fullText = '';
  for (let i = 1; i <= doc.numPages; i++) {
    const page = await doc.getPage(i);
    const content = await page.getTextContent();
    const strings = content.items.map((item: any) => item.str);
    fullText += strings.join(' ') + '\n';
  }
  
  return fullText.trim();
}

async function main() {
  if (process.argv.length < 3) {
    console.log('Usage: npm run start -- <pdf_file> [-j]');
    process.exit(1);
  }

  const pdfPath = process.argv[2];
  const jsonOutput = process.argv.includes('-j');

  try {
    const text = await extractText(pdfPath);
    if (jsonOutput) {
      console.log(JSON.stringify({ text }));
    } else {
      console.log(text);
    }
  } catch (error) {
    console.error('Error:', error);
  }
}

main();
EOL

cd ..

# Set up pdfreader (TypeScript/Node.js implementation)
cd pdfreader
npm init -y
npm install pdfreader @types/node typescript ts-node
npm pkg set type="module" scripts.build="tsc" scripts.start="node --experimental-specifier-resolution=node --loader ts-node/esm src/pdfreader_parser.ts"

cat > tsconfig.json << EOL
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "node",
    "esModuleInterop": true,
    "strict": true,
    "outDir": "./dist"
  },
  "include": ["src/**/*"],
  "ts-node": {
    "esm": true
  }
}
EOL

mkdir -p src
cat > src/pdfreader_parser.ts << EOL
import fs from "fs";

async function importPdfReader() {
    const { PdfReader } = await import("pdfreader");
    return PdfReader;
}

async function extractText(
    pdfPath: string,
    options: object = {}
): Promise<string> {
    const PdfReader = await importPdfReader();

    return new Promise((resolve, reject) => {
        let text = "";
        // Pass options to PdfReader
        new PdfReader(options).parseFileItems(pdfPath, (err, item) => {
            if (err) reject(err);
            else if (!item) {
                resolve(text.trim());
            } else if (item.text) {
                text += item.text + " ";
            }
        });
    });
}

async function main() {
    if (process.argv.length < 3) {
        console.log("Usage: npm run start -- <pdf_file> [-j]");
        process.exit(1);
    }

    const pdfPath = process.argv[2];
    const jsonOutput = process.argv.includes("-j");

    try {
        const text = await extractText(pdfPath);
        if (jsonOutput) {
            console.log(JSON.stringify({ text }));
        } else {
            console.log(text);
        }
    } catch (error) {
        console.error("Error:", error);
    }
}

main();
EOL

cd ..

# Set up pdf-parse-new (TypeScript/Node.js implementation)
cd pdf-parse-new
npm init -y
npm install pdf-parse-new @types/node typescript ts-node
npm pkg set type="module" scripts.build="tsc" scripts.start="node --experimental-specifier-resolution=node --loader ts-node/esm src/pdf_parse_new_parser.ts"

cat > tsconfig.json << EOL
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "node",
    "esModuleInterop": true,
    "strict": true,
    "outDir": "./dist"
  },
  "include": ["src/**/*"],
  "ts-node": {
    "esm": true
  }
}
EOL

mkdir -p src
cat > src/pdf_parse_new_parser.ts << EOL
import fs from "fs";

async function importPdfParseNew() {
    const pdfParseNew = await import("pdf-parse-new");
    return pdfParseNew.default;
}

async function extractText(pdfPath: string): Promise<string> {
    const dataBuffer = fs.readFileSync(pdfPath);
    const pdfParseNew = await importPdfParseNew();
    const data = await pdfParseNew(dataBuffer);
    return data.text.trim();
}

async function main() {
    if (process.argv.length < 3) {
        console.log('Usage: npm run start -- <pdf_file> [-j]');
        process.exit(1);
    }

    const pdfPath = process.argv[2];
    const jsonOutput = process.argv.includes('-j');

    try {
        const text = await extractText(pdfPath);
        if (jsonOutput) {
            console.log(JSON.stringify({ text }));
        } else {
            console.log(text);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

main();
EOL

cd ..

# Create a README file
cat > README.md << EOL
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
EOL

echo "Setup complete. See README.md for usage instructions."