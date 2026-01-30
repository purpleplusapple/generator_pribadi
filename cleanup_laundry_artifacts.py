import os

PROJECT_DIR = "44_Guest_Room_AI"
OLD_PREFIX = "laundry"
NEW_PREFIX = "guest"
OLD_CLASS = "Laundry"
NEW_CLASS = "Guest"

def replace_in_file(filepath):
    try:
        with open(filepath, 'r') as f:
            content = f.read()

        new_content = content
        # Replace imports and identifiers
        new_content = new_content.replace(f"{OLD_PREFIX}_", f"{NEW_PREFIX}_")
        new_content = new_content.replace(OLD_CLASS, NEW_CLASS)

        if content != new_content:
            with open(filepath, 'w') as f:
                f.write(new_content)
            print(f"Updated content: {filepath}")
    except Exception as e:
        print(f"Error processing {filepath}: {e}")

def rename_files():
    for root, dirs, files in os.walk(PROJECT_DIR, topdown=False):
        for filename in files:
            if OLD_PREFIX in filename:
                old_path = os.path.join(root, filename)
                new_filename = filename.replace(OLD_PREFIX, NEW_PREFIX)
                new_path = os.path.join(root, new_filename)
                os.rename(old_path, new_path)
                print(f"Renamed: {old_path} -> {new_path}")

def main():
    print(f"Starting laundry cleanup for {PROJECT_DIR}...")

    # 1. Content Replacement
    for root, dirs, files in os.walk(PROJECT_DIR):
        for filename in files:
            if filename.endswith(('.dart', '.yaml', '.xml', '.plist', '.md')):
                replace_in_file(os.path.join(root, filename))

    # 2. File Renaming
    rename_files()

    print("Cleanup complete.")

if __name__ == "__main__":
    main()
