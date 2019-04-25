#!/usr/bin/env python
import random
import json
from datetime import datetime

import web
import loremipsum


urls = (
    '/api/v1/documents/?', 'list_documents',
    '/api/v1/documents/(.*)', 'get_document'
)

categories = [
    'abstract',
    'animals',
    'business',
    'cats',
    'city',
    'food',
    'nightlife',
    'fashion',
    'people',
    'nature',
    'sports',
    'technics',
    'transport',
    'technics'
]

app = web.application(urls, globals())

def create_simple_document(i):
    title = loremipsum.get_sentence().replace('.', '')
    category = categories[(i / 14)].title()
    return {
        'id': i,
        'title': title,
        'category': category,
        'thumbnailImg': 'http://lorempixel.com/100/100/{}'.format(category.lower())
    }

def create_full_document(i):
    document = create_simple_document(i)

    headerImg = 'http://lorempixel.com/400/300/{}/{}'.format(
        document['category'].lower(),
        document['title'].replace('.', '').replace(' ', '%20')
    )
    document['headerImg'] = headerImg

    title_split = document['title'].split()
    author = '{} {}'.format(title_split[0].title(), title_split[1].title()).replace('.', '')
    document['author'] = author

    document['created'] = datetime.utcnow().isoformat()

    document['text'] = ''
    for _ in xrange(5):
        document['text'] += '<p>{}</p>'.format(loremipsum.get_paragraph())
    
    return document

class list_documents:        
    def GET(self):
        documents = { 'documents': [] }
        for i in xrange(random.randint(50, 195)):
            document = create_simple_document(i)
            documents['documents'].append(document)
        web.header('Content-Type', 'application/json')
    	return json.dumps(documents)

class get_document:
    def GET(self, document_id):

        try:
            doc_id = int(document_id)
            if 0 <= doc_id <= 195:
                web.header('Content-Type', 'application/json')
                return json.dumps(create_full_document(int(doc_id)))
            return web.notfound()
        except ValueError:
            return web.badrequest()


if __name__ == "__main__":
    app.run()