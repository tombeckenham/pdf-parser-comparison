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
