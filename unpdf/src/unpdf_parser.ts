import fs from "fs";
import { extractText } from "unpdf";

async function extractPdfText(pdfPath: string): Promise<string> {
	const buffer = new Uint8Array(fs.readFileSync(pdfPath));
	const { text } = await extractText(buffer);
	return text.join(" ");
}

async function main() {
	if (process.argv.length < 3) {
		console.log("Usage: npm run start -- <pdf_file> [-j]");
		process.exit(1);
	}

	const pdfPath = process.argv[2];
	const jsonOutput = process.argv.includes("-j");

	try {
		const text = await extractPdfText(pdfPath);
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
