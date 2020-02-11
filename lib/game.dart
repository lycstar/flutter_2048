import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_2048/number.dart';

enum Direction { UP, DOWN, LEFT, RIGHT }

class DirectionNotification extends Notification {
  Direction direction;

  DirectionNotification(this.direction);
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<List<int>> data = List(4);
  int score = 0;
  bool GAMEOVER = false;

  initNumber() {
    data = [
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0]
    ];
  }

  int RN = 4;
  int CN = 4;

  @override
  void initState() {
    super.initState();
    initNumber();
    randomNum();
    randomNum();
  }

  @override
  Widget build(BuildContext context) {
    List numbers2 = List();
    data.forEach((element) => element.forEach((e) => numbers2.add(e)));
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      score.toString(),
                      style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 40.0),
                    ),
                  ),
                ),
                Expanded(
                    child: Text(
                  GAMEOVER ? "GAMEOVER!" : "",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20.0),
                )),
              ],
            ),
          ),
          NotificationListener<DirectionNotification>(
            onNotification: (DirectionNotification directionNotification) {
              move(directionNotification.direction);
              return true;
            },
            child: Builder(
              builder: (context) => GestureDetector(
                onVerticalDragEnd: (endDetails) {
                  if (endDetails.primaryVelocity < 0.0) {
                    DirectionNotification(Direction.UP).dispatch(context);
                  } else if (endDetails.primaryVelocity > 0.0) {
                    DirectionNotification(Direction.DOWN).dispatch(context);
                  }
                },
                onHorizontalDragEnd: (endDetails) {
                  if (endDetails.primaryVelocity < 0.0) {
                    DirectionNotification(Direction.LEFT).dispatch(context);
                  } else if (endDetails.primaryVelocity > 0.0) {
                    DirectionNotification(Direction.RIGHT).dispatch(context);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.brown.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.all(8.0),
                  child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      mainAxisSpacing: 6.0,
                      crossAxisSpacing: 6.0,
                      crossAxisCount: 4,
                      padding: EdgeInsets.all(6.0),
                      children: numbers2.map((num) {
                        return Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(4.0)),
                            child: (num != 0) ? NumberWidget(num) : Container());
                      }).toList()),
                ),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  bool isGAMEOVER() {
    for (var r = 0; r < RN; r++) {
      for (var c = 0; c < CN; c++) {
        if (data[r][c] == 0) return false;
        if (c < CN - 1 && data[r][c] == data[r][c + 1]) return false;
        if (r < RN - 1 && data[r][c] == data[r + 1][c]) return false;
      }
    }
    return true;
  }

  void randomNum() {
    while (true) {
      var r = math.Random.secure().nextInt(RN);
      var c = math.Random.secure().nextInt(CN);
      if (data[r][c] == 0) {
        data[r][c] = math.Random.secure().nextDouble() < 0.5 ? 2 : 4;
        break;
      }
    }
  }

  void moveLeft() {
    var before = data.toString();
    for (var r = 0; r < RN; r++) {
      moveLeftInRow(r);
    }
    var after = data.toString();
    if (before != after) {
      randomNum();
      GAMEOVER = isGAMEOVER();
      setState(() {});
    }
  }

  void moveLeftInRow(r) {
    for (var c = 0; c < CN - 1; c++) {
      var nextc = getNextcInRow(r, c);
      if (nextc == -1)
        break;
      else {
        if (data[r][c] == 0) {
          data[r][c] = data[r][nextc];
          data[r][nextc] = 0;
          c--;
        } else if (data[r][c] == data[r][nextc]) {
          data[r][c] *= 2;
          score += data[r][c];
          data[r][nextc] = 0;
        }
      }
    }
  }

  int getNextcInRow(r, c) {
    for (var nextc = c + 1; nextc < data.length; nextc++) {
      if (data[r][nextc] != 0) return nextc;
    }
    return -1;
  }

  void moveRight() {
    var before = data.toString();
    for (var r = 0; r < RN; r++) {
      moveRightInRow(r);
    }
    var after = data.toString();
    if (before != after) {
      randomNum();
      GAMEOVER = isGAMEOVER();
      setState(() {});
    }
  }

  void moveRightInRow(r) {
    for (var c = CN - 1; c > 0; c--) {
      var prevc = getPrevcInRow(r, c);
      if (prevc == -1)
        break;
      else {
        if (data[r][c] == 0) {
          data[r][c] = data[r][prevc];
          data[r][prevc] = 0;
          c++;
        } else if (data[r][c] == data[r][prevc]) {
          data[r][c] *= 2;
          score += data[r][c];
          data[r][prevc] = 0;
        }
      }
    }
  }

  int getPrevcInRow(r, c) {
    for (var prevc = c - 1; prevc >= 0; prevc--) {
      if (data[r][prevc] != 0) return prevc;
    }
    return -1;
  }

  void moveUp() {
    var before = data.toString();
    for (var c = 0; c < CN; c++) {
      moveUpInCol(c);
    }
    var after = data.toString();
    if (before != after) {
      randomNum();
      GAMEOVER = isGAMEOVER();
      setState(() {});
    }
  }

  void moveUpInCol(c) {
    for (var r = 0; r < RN - 1; r++) {
      var nextr = getNextrInCol(r, c);
      if (nextr == -1)
        break;
      else {
        if (data[r][c] == 0) {
          data[r][c] = data[nextr][c];
          data[nextr][c] = 0;
          r--;
        } else if (data[r][c] == data[nextr][c]) {
          data[r][c] *= 2;
          score += data[r][c];
          data[nextr][c] = 0;
        }
      }
    }
  }

  int getNextrInCol(r, c) {
    for (var nextr = r + 1; nextr < RN; nextr++) {
      if (data[nextr][c] != 0) return nextr;
    }
    return -1;
  }

  void moveDown() {
    var before = data.toString();
    for (var c = 0; c < CN; c++) {
      moveDownInCol(c);
    }
    var after = data.toString();
    if (before != after) {
      randomNum();
      GAMEOVER = isGAMEOVER();
      setState(() {});
    }
  }

  void moveDownInCol(c) {
    for (var r = RN - 1; r > 0; r--) {
      var prevr = getPrevrInCol(r, c);
      if (prevr == -1)
        break;
      else {
        if (data[r][c] == 0) {
          data[r][c] = data[prevr][c];
          data[prevr][c] = 0;
          r++;
        } else if (data[r][c] == data[prevr][c]) {
          data[r][c] *= 2;
          score += data[r][c];
          data[prevr][c] = 0;
        }
      }
    }
  }

  int getPrevrInCol(r, c) {
    for (var prevr = r - 1; prevr >= 0; prevr--) {
      if (data[prevr][c] != 0) return prevr;
    }
    return -1;
  }

  void move(Direction direction) {
    switch (direction) {
      case Direction.UP:
        moveUp();
        break;
      case Direction.DOWN:
        moveDown();
        break;
      case Direction.LEFT:
        moveLeft();
        break;
      case Direction.RIGHT:
        moveRight();
        break;
    }
  }
}
