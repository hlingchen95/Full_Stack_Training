// Question 1:

// let salaries = {
//     John: 100,
//     Ann: 160,
//     Pete: 130
//   };
  
//   let sum = 0;
//   for (let key in salaries) {
//     sum += salaries[key];
//   }
  
//   console.log(sum); // 390

//Question 2:

// let menu = {
//     width: 200,
//     height: 300,
//     title: "My menu"
// };

// function multiplyNumeric(obj) {
//     for (let key in obj) {
//       if (typeof obj[key] == 'number') {
//         obj[key] *= 2;
//       }
//     }
//     console.log(obj)
// }

// multiplyNumeric(menu);

//Question 3:

// function checkEmailId(str){
//     if (str.indexOf('@') > -1)
//     {
//         if (str.indexOf('.') > -1){
//             console.log(true);
//         }
//     }
//     console.log(false);
// }

// checkEmailId("abc@gmailcom");

//Question 4:

// function truncate(str, maxlength) {
//     return (str.length > maxlength) ?
//       str.slice(0, maxlength - 1) + '…' : str;

// }

// console.log(truncate("What I'd like to tell on this topic is:", 20));

//Question 5:
let menu = ["James", "Brennie"];

menu.push("Robert");
console.log(menu);

menu[parseInt(menu.length/2)] = "Calvin";
console.log(menu);

menu = menu.slice(1,menu.length)
console.log(menu);

menu.unshift("Rose","Regal");
console.log(menu)