import 'dart:math';

import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _equation = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculator",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Container(child: Text(_equation,textScaleFactor: 3,)), buildButtonGrid()],
        ));
  }

  String evaluate(String eq) {
    print("Calculating $eq");
    
    // Count if brackets are balanced
    int openBrackets = 0;
    for(int i=0;i<eq.length;i++)
    {
      if(eq[i]=="(")
        openBrackets++;
      else if(eq[i]==")") {
        openBrackets--;
        if(openBrackets<0)
          return "Unbalanced Brackets";
      }
    }
    if(openBrackets!=0)
      return "Unbalanced Brackets";

    while(eq.contains("(")) {
      bool doBreak = false;
      for(int i=0;i<eq.length && !doBreak;i++) {
        if(eq[i]=="(") {
          for(int j=i;j<eq.length;j++){
            if(eq[j]=="(")
              i = j;
            else if(eq[j]==")"){
              eq = eq.replaceAll(eq.substring(i,j+1), evaluate(eq.substring(i+1,j)));
              doBreak = true;
              break;
            }
          }
        }
      }
    }

    // No brackets from here

    eq = solveOnePriority(eq, ["*","/"],[(x,y)=>x*y , (x,y)=>x~/y]);

    eq = solveOnePriority(eq, ["+","-"], [(x,y)=>x+y,(x,y)=>x-y]);
    return eq;
  }

  String solveOnePriority(String eq,List<String> operators,List functions)
  {
    print(eq);
    while(eq.contains(operators[0],1) || eq.contains(operators[1],1))
    {
      print(eq);
      for(int i=1;i<eq.length;i++)
      {
        if (eq[i] == operators[0] || eq[i]==operators[1])
        {
          int leftNumber = 0;
          int exp = 0;
          int j = i-1;
          RegExp findNumbers = new RegExp(r"[0-9]");
          while (j>=0 && findNumbers.hasMatch(eq[j]))
          {
            leftNumber+=int.parse(eq[j])*(pow(10, exp));
            exp++;
            j--;
          }
          int leftIndex = j+1;

          int rightNumber = 0;
          j = i+1;
          while(j<eq.length && findNumbers.hasMatch(eq[j]))
          {
            rightNumber*=10;
            rightNumber+=int.parse(eq[j]);
            j++;
          }
          int rightIndex = j;
          String op = eq[i];
          if(op==operators[0])
          {
            eq = eq.replaceAll(eq.substring(leftIndex,rightIndex), functions[0](leftNumber,rightNumber).toString());
            break;
          }
          else
          {
            eq = eq.replaceAll(eq.substring(leftIndex,rightIndex), functions[1](leftNumber,rightNumber).toString());
            break;
          }
          
        }
      }
    }
    print(eq);
    return eq;
  }



  void onTabListener(String text) {
    print("Button $text was pressed.");
    setState(() {
      switch (text) {
        case "DEL":
          _equation = _equation.substring(0, _equation.length - 1);
          break;
        case "C":
          _equation = "";
          break;
        case "=":
          _equation = evaluate(_equation);
          break;
        default:
          _equation += text;
      }

      print("eq: $_equation");
    });
  }

  Widget buildButton(String text) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          color: Colors.lightBlueAccent,
            child: Center(child: Text(text)),

        ),
      ),
      onTap: () => onTabListener(text),
    );
  }

  Widget buildButtonGrid() {
    print("Building Button Grid");
    Widget grid = GridView(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      shrinkWrap: true,
      children: <Widget>[
        buildButton("C"),
        buildButton("DEL"),
        buildButton("/"),
        buildButton("*"),
        buildButton("7"),
        buildButton("8"),
        buildButton("9"),
        buildButton("-"),
        buildButton("4"),
        buildButton("5"),
        buildButton("6"),
        buildButton("+"),
        buildButton("1"),
        buildButton("2"),
        buildButton("3"),
        buildButton("="),
        buildButton("0"),
        buildButton("."),
        buildButton("("),
        buildButton(")"),
      ],
    );
    return grid;
  }
}
