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
