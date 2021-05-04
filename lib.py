import pytest

PYTEST = False


def fmt(file_type, buffer_string):
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
        json_object = json.loads(buffer_string)
        return json.dumps(json_object, indent=2).split('\n')



# Pytesting

def test_fmt(mocker):

    buffer_string = '''
    <note>
      <to>Tove</to>
      <from>Jani</from>
      <heading>Reminder</heading>
      <body>Don't forget me this weekend!</body>
    </note>
    '''

    print(fmt('hola.xml', buffer_string))


if __name__ == '__main__':

    pytest.main(['-s', __file__])

