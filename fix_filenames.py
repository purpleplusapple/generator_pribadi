import os

RENAME_MAP = {
    'lib/model/shoe_ai_config.dart': 'lib/model/terrace_ai_config.dart',
    'lib/services/shoe_result_storage.dart': 'lib/services/terrace_result_storage.dart',
}

IMPORT_REPLACEMENTS = {
    'shoe_ai_config.dart': 'terrace_ai_config.dart',
    'shoe_result_storage.dart': 'terrace_result_storage.dart',
}

ROOT_DIR = '38_Balcony_Terrace_AI'

def main():
    # 1. Rename files
    for old, new in RENAME_MAP.items():
        old_path = os.path.join(ROOT_DIR, old)
        new_path = os.path.join(ROOT_DIR, new)
        if os.path.exists(old_path):
            os.rename(old_path, new_path)
            print(f"Renamed {old} -> {new}")
        else:
            print(f"File not found: {old}")

    # 2. Update imports
    for root, dirs, files in os.walk(ROOT_DIR):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()

                    new_content = content
                    for old_imp, new_imp in IMPORT_REPLACEMENTS.items():
                        new_content = new_content.replace(old_imp, new_imp)

                    if content != new_content:
                        with open(filepath, 'w', encoding='utf-8') as f:
                            f.write(new_content)
                        print(f"Updated imports in {file}")
                except Exception as e:
                    print(f"Error processing {file}: {e}")

if __name__ == '__main__':
    main()
