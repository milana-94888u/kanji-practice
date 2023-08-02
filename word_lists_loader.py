from html.parser import HTMLParser
import json

import requests


class HTMLSimpleListParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.is_list_started = False
        self.is_list_item = False
        self.words_list: list[str] = []

    def handle_starttag(self, tag: str, attrs: list) -> None:
        if tag == "ol":
            self.is_list_started = True
        elif tag == "li" and self.is_list_started:
            self.is_list_item = True
            self.words_list.append([])

    def handle_endtag(self, tag: str) -> None:
        if tag == "ol":
            self.is_list_started = False
        if tag == "li":
            self.is_list_item = False

    def handle_data(self, data: str) -> None:
        if self.is_list_item:
            self.words_list[-1].append(data)



class HTMLKatakanaListParser(HTMLParser):
    def __init__(self, words_list: list[str]) -> None:
        super().__init__()
        self.lists_count = 0
        self.is_list_started = False
        self.is_list_item = False
        self.is_exact_list_end = False
        self.words_list: list[str] = words_list

    def handle_starttag(self, tag: str, attrs: list) -> None:
        if tag == "ul":
            self.lists_count += 1
            if self.lists_count == 2 and self.is_exact_list_end:
                self.is_list_started = True
        elif tag == "li" and self.is_list_started:
            self.is_list_item = True
            self.words_list.append([])
        self.is_exact_list_end = False

    def handle_endtag(self, tag: str) -> None:
        self.is_exact_list_end = False
        if tag == "ul":
            self.is_exact_list_end = True
            self.is_list_started = False
        if tag == "li":
            self.is_list_item = False

    def handle_data(self, data: str) -> None:
        if self.is_list_item:
            self.words_list[-1].append(data)


class HTMLMarkedListParser(HTMLParser):
    def __init__(self, words_list: list[str]) -> None:
        super().__init__()
        self.lists_count = 0
        self.is_list_started = False
        self.is_list_item = False
        self.words_list: list[str] = words_list

    def handle_starttag(self, tag: str, attrs: list) -> None:
        if tag == "ul":
            self.lists_count += 1
            if self.lists_count == 1:
                self.is_list_started = True
        elif tag == "li" and self.is_list_started:
            self.is_list_item = True
            self.words_list.append([])

    def handle_endtag(self, tag: str) -> None:
        if tag == "ul":
            self.is_list_started = False
        if tag == "li":
            self.is_list_item = False

    def handle_data(self, data: str) -> None:
        if self.is_list_item:
            self.words_list[-1].append(data)



if __name__ == "__main__":
    result = {"jlpt": {}, "frequent": {}}
    for jlpt_level in ["N5", "N4"]:
        parser = HTMLSimpleListParser()
        parser.feed(requests.get(f"https://en.wiktionary.org/wiki/Appendix:JLPT/{jlpt_level}").text)
        result["jlpt"][jlpt_level] = parser.words_list
    for jlpt_level in ["N3", "N2", "N1"]:
        words_list = []
        for first_syllable in ['あ', 'か', 'さ', 'た', 'な', 'は', 'ま', 'や', 'ら', 'わ']:
            parser = HTMLMarkedListParser(words_list)
            parser.feed(requests.get(f"https://en.wiktionary.org/wiki/Appendix:JLPT/{jlpt_level}/{first_syllable}行").text)
        parser = HTMLKatakanaListParser(words_list)
        parser.feed(requests.get(f"https://en.wiktionary.org/wiki/Appendix:JLPT/{jlpt_level}").text)
        result["jlpt"][jlpt_level] = words_list
    parser = HTMLSimpleListParser()
    parser.feed(requests.get("https://en.wiktionary.org/wiki/Wiktionary:Frequency_lists/Japanese/Wikipedia2013").text)
    for i in range(10):
        result["frequent"][f"frequent{(i + 1) * 1000}"] = parser.words_list[i * 1000:(i + 1) * 1000]
    with open("words_list.json", "w") as f:
        json.dump(result, f, ensure_ascii=False)
