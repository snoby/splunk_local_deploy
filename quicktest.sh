
curl -v -u "x:5d528020-516b-4c30-8451-c1ff48726527" \
            "http://localhost:8088/services/collector/raw" \
-d '{ "timestamp": "2020-05-02T12:20:02.804-0500Z","yourdata":"Timestamp with timezone","subfieldstuff" :{"moredata": "bar"}}'
