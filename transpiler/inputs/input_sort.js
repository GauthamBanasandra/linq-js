function linq_query() {
    var fruits = ['apple', 'mango', 'banana', 'grapes'];
    var new_fruits =
        (function () {
            var s1 =
                (function () {
                    if (typeof fruits === 'undefined')
                        throw 'line 7: fruits is undefined';
                    if (!(fruits instanceof Array))
                        throw 'line 7: expected list for "fruits" but got ' + typeof fruits;

                    var newList = [],
                        fru,
                        selMultiple = false;

                    if ('fru'.includes(',')) {
                        selMultiple = true;
                    }

                    for (fru of fruits) {
                        if (true) {
                            if (selMultiple) {
                                newList.push([fru]);
                            } else {
                                newList.push(fru);
                            }
                        }
                    }
                    return newList;
                })();
            var s2 =
                (function () {
                    if (typeof s1 === 'undefined')
                        throw 'line 7: s1 is undefined';
                    if (!(s1 instanceof Array))
                        throw 'line 7: expected list for "s1" but got ' + typeof s1;

                    var newList = [],
                        fr,
                        selMultiple = false;

                    if ('fr'.includes(',')) {
                        selMultiple = true;
                    }

                    for (fr of s1) {
                        if (fr.length <= 5) {
                            if (selMultiple) {
                                newList.push([fr]);
                            } else {
                                newList.push(fr);
                            }
                        }
                    }
                    return newList;
                })();
            var s3 =
                (function () {
                    var fruit,
                        nfl = {};
                    for (fruit of s2) {
                        if (fruit.length == 5) {
                            if (nfl[fruit.length]) {
                                nfl[fruit.length].push(fruit);
                            } else {
                                nfl[fruit.length] = [fruit];
                            }
                        }
                    }

                    return nfl;
                })();
            return s3;
        })();
    console.log(new_fruits);
}
linq_query();
