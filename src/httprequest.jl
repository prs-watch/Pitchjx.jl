using HTTP
using EzXML

function gethtml(url)
    r = HTTP.get(url)
    if 200 <= r.status < 300
        return root(parsehtml(String(r.body)))
    else
        error("Page is not accessable.")
    end
end

function getxml(url)
    r = HTTP.get(url)
    if 200 <= r.status < 300
        return root(parsexml(String(r.body)))
    else
        error("Page is not accessable.")
    end
end
