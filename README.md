# generate-and-store-QR-to-any-database
a complete code about how to generate Qr code and store it in any db ( firebase used in this example)

when you generate a QR code using : qr_flutter package , you can not upload it directly to a database , so you have to used 'RepaintBoundary' widget to take a screenshot of th 'qr_flutter' package . After taking a screenshot you can easily upload the picture to any DB using the link that you gave to that pic

## used packages :
  - qr_flutter: ^4.0.0
  - http: any
  - firebase_core: ^1.12.0
  - cloud_firestore: any
  - image_picker: ^0.8.4+10
  -  firebase_storage: ^10.2.9
