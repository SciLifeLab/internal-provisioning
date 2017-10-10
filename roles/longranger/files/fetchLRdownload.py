import re
import requests
from bs4 import BeautifulSoup

url="https://support.10xgenomics.com/genome-exome/software/downloads/latest"
cookies={'sw-eula':'s%3Aj%3A%7B%22email%22%3A%22seqmaster%40scilifelab.se%22%7D.Hqk33VoDuufsNpnSR7DF32NL4ifRnRZSyCykMynwMME'}
pat=re.compile('"(http.+)"')
r=requests.get(url, verify=False, cookies=cookies)
data=BeautifulSoup(r.text, "html.parser")
st=data.find_all("div", class_="download-command")[0].text
link = pat.findall(st)[0]
print link
