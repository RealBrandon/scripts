template_file = open("./geofeed_template.html", "rt", encoding="utf-8")
csv_file = open("./AS53616.csv", "rt", encoding="utf-8")

html_head = list()
for i in range(8):
    html_head += template_file.readline()
html_body = csv_file.readlines()
html_tail = template_file.readlines()

template_file.close()
csv_file.close()

html_file = open("./geofeed.html", "wt", encoding="utf-8")
html_file.writelines(html_head + html_body + html_tail)
html_file.close()
