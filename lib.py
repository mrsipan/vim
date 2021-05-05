try:
    import pytest
except ImportError:

PYTEST = False


def fmt(file_type: bytes, buffer_string: str) -> 'bytes or a string?':
    '''Gets the format and the text and tries to make it pretty
    '''

    if file_type == b'xml':
        import lxml.etree
        import io
        parser = lxml.etree.XMLParser(remove_blank_text=True)
        tree = lxml.etree.parse(
            io.BytesIO(buffer_string.encode('utf-8')), parser
            )
        return lxml.etree.tostring(tree, pretty_print=True).split(b'\n')

    elif file_type == b'json':
        import json
        return json.dumps(json.loads(buffer_string), indent=2).split('\n')

    elif file_type in (b'html', b'htm'):
        # Better to depend on the editor formatter
        import bs4
        return bs4.BeautifulSoup(
            buffer_string,
            features='lxml',
            ).prettify().split('\n')


# Pytesting

def test_fmt(mocker):
    _buffer_string = '''
    <note>
      <to>Tove</to>
      <from>Jani</from>
      <heading>Reminder</heading>
      <body>Don't forget me this weekend!</body>
    </note>
    '''
    print(fmt(b'xml', _buffer_string))


if __name__ == '__main__':

    pytest.main(['-s', __file__])

