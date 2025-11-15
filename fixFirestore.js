import { initializeApp, cert } from "firebase-admin/app";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import fs from "fs";

const serviceAccount = JSON.parse(
  fs.readFileSync("./serviceAccountKey.json", "utf8")
);

initializeApp({
  credential: cert(serviceAccount),
});

const db = getFirestore();

async function fixApartments() {
  const snapshot = await db.collection("apartments").get();

  for (const doc of snapshot.docs) {
    const data = doc.data();

    // Handle image/video migration
    if (data.imageUrl && !data.mediaUrl) {
      const url = data.imageUrl.toLowerCase();
      const mediaType =
        url.endsWith(".mp4") || url.endsWith(".mov") ? "video" : "image";

      await doc.ref.update({
        mediaUrl: data.imageUrl,
        mediaType: mediaType,
      });

      await doc.ref.update({ imageUrl: FieldValue.delete() });
      console.log(`✅ Updated media for ${doc.id} (${mediaType})`);
    }

    // Ensure price is stored as a number
    if (typeof data.price === "string") {
      await doc.ref.update({ price: parseFloat(data.price) });
      console.log(`💰 Fixed price for ${doc.id}`);
    }
  }

  console.log("🎉 Firestore update complete!");
}

fixApartments();
