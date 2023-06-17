import shutil
import os

zip_name = "lambda_payload"

if not os.path.exists(f"file_notification_lambda/{zip_name}.zip"):
    shutil.make_archive(
        zip_name,
        format="zip",
        root_dir="lambda_payload/",
    )

    shutil.move(f"{zip_name}.zip", f"file_notification_lambda/{zip_name}.zip")

    print("zip file successfully created")
else:
    print("file already exists")
