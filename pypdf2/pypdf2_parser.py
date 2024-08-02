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
