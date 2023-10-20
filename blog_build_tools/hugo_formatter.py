"""
Brandon Han
11 Feb 2023
This script converts my articles written in MarkDown to the format used by the Hugo website builder.

29 Jun 2023
Add detection for README.md so that script won't run into error when the file is not present.
"""

import os

REPO_PATH = '/home/ubuntu/brandonhan.net/github_repo/'
EXPORT_PATH = '/home/ubuntu/brandonhan.net/formatter_export/'


def PickArticles():
    file_list = os.listdir(REPO_PATH)
    article_list = list()
    for file in file_list:
        if file.endswith('.md'):
            article_list.append(file)

    # README.md is not to be published on the website.
    if "README.md" in article_list:
        article_list.remove('README.md')

    return article_list


def GetHashtags(line: str):
    words = line.split()
    hashtags = list()
    for item in words:
        if item.startswith('#'):
            hashtags.append(item)
    return hashtags


def ConstructNewHeader(old_header: list, filename: str):
    title = filename.removesuffix('.md')
    tags = GetHashtags(old_header[0])
    categories = GetHashtags(old_header[1])
    date = old_header[2].split()[1]

    new_header = ['+++\n',
                  f"title = '{title}'\n",
                  f"date = '{date}'\n",
                  f"categories = {categories}\n",
                  f"tags = {tags}\n",
                  '+++\n']
    return new_header


def EditHeader(articles: list):
    for filename in articles:
        print()
        print(f'Handling {filename} at the moment...')

        file_path = REPO_PATH + filename
        file = open(file_path, 'rt')
        content = file.readlines()
        file.close()

        old_header = list()
        for i in range(3):  # Remove the old header from the original content.
            old_header.append(content.pop(0))
            # Element 0 is always popped since all elements shift forwards after popping.
        new_header = ConstructNewHeader(old_header, filename)

        file_path = EXPORT_PATH + filename
        file = open(file_path, 'wt')
        file.writelines(new_header + content)
        file.close()
        print('New file with Hugo-format header generated')


if __name__ == '__main__':
    articles = PickArticles()
    print('The following articles are found:')
    for item in articles:
        print(item)
    EditHeader(articles)
