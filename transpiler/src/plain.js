function linq_query()
{
	var fruits = ['apple', 'mango', 'banana', 'grapes'];
	var new_fruits =
				 
                 
                 
  
(function (){
	if(typeof fruits === 'undefined')
		throw 'line 6: fruits is undefined';
	if(!(fruits instanceof Array))
		throw 'line 6: expected list for "fruits" but got '+typeof fruits;
	var i=0,
		newList=[],
		fruit;
	for(i in fruits){
		fruit=fruits[i];
		if(2){
			newList.push(fruit);
		}
	}
	return newList;
})();
	console.log(new_fruits);
}
linq_query();
