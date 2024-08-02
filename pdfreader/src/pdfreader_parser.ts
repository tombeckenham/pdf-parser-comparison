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
