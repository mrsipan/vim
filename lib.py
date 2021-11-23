def fmt_decorator(fn):
    def decorator(*a):
        try:
            rv = fn(*a)
        except ValueError:
            print('No formatter available')
            return a[1]
        else:
            print('Formatted')
            # Add an newline on every formatting
            return [*rv, '\n']
    return decorator

@fmt_decorator
def fmt(file_type: bytes, buff: list):
    '''Gets the format and the text and tries to make it pretty
    '''
    buff = '\n'.join(buff)
    if file_type == b'xml':
        import lxml.etree, io
        parser = lxml.etree.XMLParser(remove_blank_text=True)
        tree = lxml.etree.parse(
            io.BytesIO(buff.encode('utf-8')), parser
            )
        return lxml.etree.tostring(
            tree, pretty_print=True).strip().split(b'\n')

    elif file_type == b'json':
        import json
        json_object = json.loads(buff)
        return json.dumps(json_object, indent=2).strip().split('\n')

    elif file_type == b'sql':
        import sqlparse
        return sqlparse.format(
            buff,
            # identifier_case='lower',
            comma_fist=False,
            indent_tabs=False,
            indent_width=2,
            keyword_case='upper',
            reindent=True,
            reindent_aligned=True,
            use_space_around_operators=True,
            ).strip().split('\n')
    else:
        raise ValueError()

# Pytesting

def test_fmt(mocker):

    buff = '''
    <note>
      <to>Tove</to>
      <from>Jani</from>
      <heading>Reminder</heading>
      <body>Don't forget me this weekend!</body>
    </note>
    '''

    print(fmt('hola.xml', buff))


if __name__ == '__main__':

    global PYTEST
    PYTEST = False

    import pytest
    pytest.main(['-s', __file__])

