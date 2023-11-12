#!/usr/bin/python3
# -*- coding: utf-8 -*-

from ebooklib import epub
import os

#set up the epub file
book = epub.EpubBook()
book.set_title("my_comic_book")
book.set_language('en')

content = [u'<html> <head></head> <body>']

for filename in os.listdir("images"):
  if filename.endswith(".jpg"):
    image_file = open("images/" + filename, 'rb').read()
    image = epub.EpubImage()
    image.file_name = "images/" + filename
    image.content = image_file
    book.add_item(image)
    content.append('<img src="images/{}"/>'.format(filename))

content.append('</body> </html>')
c1 = epub.EpubHtml(title='Images', file_name='images.xhtml', lang='en')
c1.content=''.join(content)

book.add_item(c1)
book.spine = ['nav', c1]

#write epub to file
epub.write_epub("my_comic.epub", book, {})
