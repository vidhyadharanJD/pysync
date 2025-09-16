import os
import time
import shutil
import oci
import json

# ========== LOAD CONFIG ==========
with open("config.json", "r") as f:
    cfg = json.load(f)

BASE_DIR = os.path.join(os.getcwd(), "UIN_DATA")

FOLDERS = {
    "D1": {"prefix": "D1", "backup": "BKP_D1"},
    "D2": {"prefix": "D2", "backup": "BKP_D2"},
    "D3": {"prefix": "D3", "backup": "BKP_D3"},
}

# OCI CONFIG
config = {
    "user": cfg["USER_OCID"],
    "key_file": cfg["PRIVATE_KEY_PATH"],
    "fingerprint": cfg["FINGERPRINT"],
    "tenancy": cfg["TENANCY_OCID"],
    "region": cfg["REGION"]
}

NAMESPACE = cfg["NAMESPACE"]
BUCKET_NAME = cfg["BUCKET_NAME"]
CHECK_INTERVAL = cfg["CHECK_INTERVAL"]

object_storage = oci.object_storage.ObjectStorageClient(config)


def ensure_backup_folders():
    """Make sure backup folders exist locally"""
    for folder, info in FOLDERS.items():
        backup_path = os.path.join(BASE_DIR, info["backup"])
        if not os.path.exists(backup_path):
            os.makedirs(backup_path)


def upload_file(prefix, file_path):
    """Upload file to bucket under specific prefix"""
    try:
        object_name = f"{prefix}/{os.path.basename(file_path)}"
        with open(file_path, "rb") as f:
            object_storage.put_object(NAMESPACE, BUCKET_NAME, object_name, f)
        return True
    except Exception as e:
        print(f"❌ Failed to upload {file_path}: {e}")
        return False


def monitor_and_upload():
    ensure_backup_folders()
    print("✅ Monitoring started...")
    while True:
        for folder, info in FOLDERS.items():
            folder_path = os.path.join(BASE_DIR, folder)
            backup_path = os.path.join(BASE_DIR, info["backup"])
            prefix = info["prefix"]

            if not os.path.exists(folder_path):
                continue

            for file_name in os.listdir(folder_path):
                file_path = os.path.join(folder_path, file_name)
                if os.path.isdir(file_path):
                    continue

                print(f"📤 Uploading {file_name} to {BUCKET_NAME}/{prefix} ...")
                if upload_file(prefix, file_path):
                    shutil.move(file_path, os.path.join(backup_path, file_name))
                    print(f"✅ Uploaded & moved {file_name} → {backup_path}")

        time.sleep(CHECK_INTERVAL)


if __name__ == "__main__":
    monitor_and_upload()
