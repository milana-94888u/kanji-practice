import json


with open("kanji_lists.json") as f:
    data = json.load(f)

result = {}

for kanji_list in data:
    if kanji_list in ["katakana", "hiragana"]:
        target_dict = result.setdefault("kana", {})
    elif kanji_list.startswith("kanji_jlpt"):
        target_dict = result.setdefault("jlpt", {})
    elif kanji_list.startswith("kanji_kanken"):
        if kanji_list.endswith("1") or kanji_list.endswith("1.5"):
            target_dict = result.setdefault("advanced", {})
        elif kanji_list.endswith("2") or kanji_list.endswith("2.5") or kanji_list.endswith("3") or kanji_list.endswith("4"):
            target_dict = result.setdefault("secondary", {})
        else:
            target_dict = result.setdefault("primary", {})
    elif kanji_list.startswith("kanji_jinmeiyou"):
        target_dict = result.setdefault("jinmeiyou", {})
    else:
        target_dict = result.setdefault("user", {})
    target_dict[kanji_list.replace(".5", "pre")] = data[kanji_list]


with open("writing_kanji_lists.json", "w") as f:
    json.dump(result, f, ensure_ascii=False)
with open("recognition_kanji_lists.json", "w") as f:
    json.dump(result, f, ensure_ascii=False)
