/**
 * Created by gautham on 16/01/17.
 */
var students = [];
for (var i = 0; i < 10; ++i) {
    var student = {};
    student['name'] = 'xyz' + i;
    student['rollno'] = Math.floor(Math.random() * 6) + 1;
    students.push(student);
}
var students1 = [];
for (; i < 20; ++i) {
    var student = {};
    student['name'] = 'xyz' + i;
    student['rollno'] = Math.floor(Math.random() * 6) + 1;
    students1.push(student);
}

var same_roll = (function (list1, list2, key) {
    var i,
        newList = new Set();
    for (i = 0; i < list1.length; ++i)
        for (var j = 0; j < list2.length; ++j)
            if (list1[i][key] === list2[j][key])
                newList.add([list1[i], list2[j]]);

    return newList;
})(students, students1, 'rollno');
console.log('same roll no');
console.log(same_roll);