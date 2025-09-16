# pysync
UIN Uploader
Folder Structure
A simple Windows-based auto uploader that monitors folders and uploads files to an OCI Object Storage bucket.
After upload, files are automatically moved to backup folders.

UIN_Uploader/
│
├── main.py                  # Main Python script
├── config.json              # JSON file with OCI details
├── requirements.txt         # Dependencies
├── start.bat                # Windows batch file to start the script
│
├── UIN_DATA/                # Root folder for client data
│   ├── D1/                  # Input folder for D1 files
│   ├── D2/                  # Input folder for D2 files
│   ├── D3/                  # Input folder for D3 files
│   ├── BKP_D1/              # Backup folder after upload
│   ├── BKP_D2/
│   ├── BKP_D3/
│
└── Config/
    └── oci_api_key.pem      # OCI private key file

  Step 1: Install Python

    install_python.bat
    Right-click → Run as Administrator.

  Step 2: Download UIN Uploader
  git clone https://github.com/vidhyadharanJD/pysync.git

  Step 3: Install Dependencies
  Open Command Prompt inside the folder and run:
   pip install -r requirements.txt

   ⚙️ Step 4: Configure OCI Details
  
    {
      "TENANCY_OCID": "ocid1.tenancy.oc1....",
      "USER_OCID": "ocid1.user.oc1....",
      "FINGERPRINT": "xx:xx:xx:xx:xx",
      "PRIVATE_KEY_PATH": "Config/oci_api_key.pem",
      "REGION": "ap-hyderabad-1",
      "NAMESPACE": "your_namespace",
      "BUCKET_NAME": "psync",
      "CHECK_INTERVAL": 5
    }

    ⚙️ Step 5: Run the Uploader

    python main.py

    🚀 Auto Start (Optional)

If you want this uploader to run automatically on startup:

Press Win + R → type shell:startup

Copy start.bat into that folder

Now the uploader will launch every time Windows starts.

