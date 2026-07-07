import requests
from bs4 import BeautifulSoup
import time
from urllib.parse import unquote, urljoin

# 1. 긁어올 소설의 정확한 위키문헌 주소
toc_url = "https://ko.wikisource.org/wiki/날개"

# 2. ⭐️ 핵심 1: 나 파이썬(봇) 아니고 맥북 쓰는 사람이야! (서버 차단 방지)
headers = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
}

print("🔍 웹페이지에 접속합니다...")
# 헤더를 포함해서 요청
response = requests.get(toc_url, headers=headers)

# 💡 디버깅 1: 서버가 정상적으로 응답했는지 확인 (200이 나오면 정상!)
print(f"📡 서버 응답 코드: {response.status_code}")

soup = BeautifulSoup(response.text, 'html.parser')
all_links = soup.select('.mw-parser-output a')

# 💡 디버깅 2: 페이지에서 링크를 몇 개나 찾았는지 확인
print(f"🔗 페이지에서 찾은 전체 링크 개수: {len(all_links)}개\n")

# 3. ⭐️ 핵심 2: 기준 경로 추출 (예: '/wiki/무정_(이광수)')
# 사용자가 입력한 URL에서 위키 기본 주소만 딱 잘라냅니다.
base_path = unquote(toc_url.replace("https://ko.wikisource.org", ""))
visited_links = set()

with open("novel_full.txt", "w", encoding="utf-8") as file:
    for a_tag in all_links:
        link = a_tag.get('href')
        title = a_tag.text.strip()

        if link and link.startswith("/wiki/"):
            decoded_link = unquote(link)
            
            # 4. 하위 문서 확인: '/wiki/무정_(이광수)/' 로 시작하는 링크만 싹 다 긁어옴!
            # 이렇게 하면 링크 이름이 뭔지 몰라도 무조건 해당 소설의 챕터만 가져옵니다.
            if decoded_link.startswith(base_path + "/") and link not in visited_links:
                visited_links.add(link)
                chapter_url = urljoin(toc_url, link)
                
                print(f"📖 [{title}] 긁어오는 중...")
                
                chap_res = requests.get(chapter_url, headers=headers)
                chap_soup = BeautifulSoup(chap_res.text, 'html.parser')
                
                paragraphs = chap_soup.select('.mw-parser-output p')
                text = "\n".join([p.text for p in paragraphs])
                
                file.write(f"\n\n=== {title} ===\n\n")
                file.write(text)
                
                time.sleep(1)

print("\n🎉 크롤링 완료! 'novel_full.txt' 파일을 확인해주세요.")