const functions = require("firebase-functions");
const express = require("express");
const admin = require("firebase-admin");
const axios = require("axios");
const { user } = require("firebase-functions/v1/auth");

admin.initializeApp(functions.config.firebase);

const app = express();

//ANCHOR Add New User

app.post("/newuser", async (req, res) => {
  const { uid, phoneNumber, referCode, url, cmg } = req.body;

  const currentTime = admin.firestore.FieldValue.serverTimestamp();
  const referenceId = Date.now().toString();

  await admin.firestore().collection("users").doc(uid).set({
    id: uid,
    phone: phoneNumber,
    profilePicture:
      "https://firebasestorage.googleapis.com/v0/b/ipoll-da231.appspot.com/o/profilePic%2Fblank.png?alt=media&token=2d62b060-d222-4f42-8bd8-3674246136f6",
    name: "",
    wallet: 0,
    email: "",
    cmg,
    upiId: "",
    pancard: "",
    createdAt: currentTime,
    week: 0,
    all: 0,
    code: referCode,
    link: url,
    firstlogin: false,
    referrer: "",
  });

  await admin.firestore().collection("userranking").doc(uid).set({
    alltime: 100,
    weekly: 100,
    image:
      "https://firebasestorage.googleapis.com/v0/b/ipoll-da231.appspot.com/o/profilePic%2FJH1CsXrWshRFDc3R0qTGBAtoO383?alt=media&token=84985b5f-86c7-47d9-a52d-a08ca13a9766",
    name: "iPOLL User",
  });

  await admin
    .firestore()
    .collection("users")
    .doc(uid)
    .collection("transcations")
    .doc(referenceId)
    .set({
      referenceId: referenceId,
      amount: "100",
      orderId: "notrequired",
      type: "Initial Promo Amount",
      isDebit: false,
      time: currentTime,
    });

  await admin
    .firestore()
    .collection("users")
    .doc(uid)
    .collection("sec")
    .doc("wallet")
    .set({
      amount: 0,
      promo: 100,
      total: 100,
    });

  await axios.post(
    "https://hooks.slack.com/services/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",
    {
      text: `A new user has registered ${phoneNumber}`,
    }
  );

  res.status(200).send("success");
});

//ANCHOR Update UserReward

//ANCHOR Get All Users for Push Notification

app.get("/getalluserpush", async (req, res) => {
  let users = [];

  const snapshot = await admin.firestore().collection("users").get();

  snapshot.forEach((doc) => {
    if (doc.data().cmg.length > 0) {
      users.push(doc.data().cmg);
    }
  });

  res.status(200).send({ users: users });
});

//ANCHOR Update Wallet

app.post("/updatewallet", async (req, res) => {
  console.log(req.body.orderId);
  const { uid, amount, orderId, referenceId } = req.body;

  const currentTime = admin.firestore.FieldValue.serverTimestamp();

  try {
    // await admin
    //   .firestore()
    //   .collection("users")
    //   .doc(uid)
    //   .collection("sec")
    //   .doc("wallet")
    //   .get()
    //   .then((doc) => {
    //     if (!doc.exists) {
    //       console.log("no such doc");
    //     } else {
    //       console.log(doc.data().amount);
    //       // console.log(doc.get(wallet));
    //       console.log(amount);
    //       const newAmount = parseFloat(amount);
    //       console.log(newAmount);
    //       const newCount = doc.data().amount + Number(newAmount);
    //       const newTotal = doc.data().total + Number(newAmount);
    //       console.log(newCount);
    //       admin
    //         .firestore()
    //         .collection("users")
    //         .doc(uid)
    //         .collection("sec")
    //         .doc("wallet")
    //         .update({
    //           amount: newCount,
    //           total: newTotal,
    //         });
    //     }

    //   });

    //testing incremenet feature
    const newAmount = parseFloat(amount);

    admin
      .firestore()
      .collection("users")
      .doc(uid)
      .collection("sec")
      .doc("wallet")
      .update({
        amount: admin.firestore.FieldValue.increment(newAmount),
        total: admin.firestore.FieldValue.increment(newAmount),
      });

    await admin
      .firestore()
      .collection("users")
      .doc(uid)
      .collection("transcations")
      .doc(referenceId)
      .set({
        referenceId: referenceId,
        amount: amount,
        orderId: orderId,
        type: "RECHARGE",
        isDebit: false,
        time: currentTime,
      });

    res.status(200).send("success");
  } catch (error) {
    console.log(error);
    res.status(400).send(error);
  }
});

app.post("/updatepoll", async (req, res) => {
  const {
    uid,
    amount,
    questionId,
    question,
    image,
    selectedOption,
    isSecondOption,
    secondOption,
    referenceId,
    orderId,
    time,
  } = req.body;
  const currentTime = admin.firestore.FieldValue.serverTimestamp();

  // set user particapted poll for individual
  await admin
    .firestore()
    .collection("users")
    .doc(uid)
    .collection("participatedpolls")
    .doc(questionId)
    .set({
      questionId: questionId,
      question: question,
      image: image,
      selectedAmount: amount,
      submittedTime: currentTime,
      selectedOption: selectedOption,
      secondOption: secondOption,
      secondOptionRequired: isSecondOption == "true" ? true : false,
      resultDeclared: false,
      youWon: false,
      winningAmount: 0,
      isLive: true,
      time: time,
      majority: "",
    });

  await admin
    .firestore()
    .collection("questions")
    .doc(questionId)
    .collection("submissions")
    .doc(uid)
    .set({
      userid: uid,
      selectedAmount: amount,
      questionId: questionId,
      selectedOption: selectedOption,
      secondOption: secondOption,
      hasWon: false,
      winningamt: 0,
    });

  //update QUESTION -> ANALTICS -> FIRSTQUESTION
  // amount: admin.firestore.FieldValue.increment(userincome),

  await admin
    .firestore()
    .collection("questions")
    .doc(questionId)
    .collection("analyticsdata")
    .doc("firstquestion")
    .update({
      [selectedOption]: admin.firestore.FieldValue.increment(+1),
    });

  // await admin
  //   .firestore()
  //   .collection("questions")
  //   .doc(questionId)
  //   .collection("analyticsdata")
  //   .doc("firstquestion")
  //   .get()
  //   .then((doc) => {
  //     if (!doc.exists) {
  //       console.log("no such doc");
  //     } else {
  //       console.log(doc.get(selectedOption));
  //       const newCount = doc.get(selectedOption) + 1;
  //       console.log(newCount);
  //       admin
  //         .firestore()
  //         .collection("questions")
  //         .doc(questionId)
  //         .collection("analyticsdata")
  //         .doc("firstquestion")
  //         .update({
  //           [selectedOption]: newCount,
  //         });
  //     }
  //   });

  //update QUESTION -> ANALTICS -> FIRSTQUESTIONAMT
  await admin
    .firestore()
    .collection("questions")
    .doc(questionId)
    .collection("analyticsdata")
    .doc("firstquestionamt")
    .get()
    .then((doc) => {
      if (!doc.exists) {
        console.log("no such doc");
      } else {
        const newCount = doc.get(selectedOption) + parseInt(amount);
        console.log(newCount);
        admin
          .firestore()
          .collection("questions")
          .doc(questionId)
          .collection("analyticsdata")
          .doc("firstquestionamt")
          .update({
            [selectedOption]: newCount,
          });
      }
    });
  //Update question particpant & revenue generated
  await admin
    .firestore()
    .collection("questions")
    .doc(questionId)
    .get()
    .then((doc) => {
      if (!doc.exists) {
        console.log("no such doc");
      } else {
        console.log(doc.get("totalparticpants"));
        const newCount = doc.get("totalparticpants") + 1;

        const newrevenueCount = doc.get("rvg") + parseInt(amount);
        console.log(newCount);
        admin.firestore().collection("questions").doc(questionId).update({
          totalparticpants: newCount,
          rvg: newrevenueCount,
        });
      }
    });

  await admin
    .firestore()
    .collection("users")
    .doc(uid)
    .collection("transcations")
    .doc(referenceId)
    .set({
      referenceId: referenceId,
      amount: amount,
      orderId: orderId,
      type: "INSTANT",
      time: currentTime,
    });

  console.log("success");

  res.status(200).send("abc");
});

//ANCHOR submit poll - version 2

app.post("/submitpollv2", async (req, res) => {
  const {
    uid,
    amount,
    questionId,
    question,
    image,
    selectedOption,
    isSecondOption,
    secondOption,
    time,
  } = req.body;

  const currentTime = admin.firestore.FieldValue.serverTimestamp();

  const referenceId = Date.now().toString();

  try {
    const newAmount = parseFloat(amount);

    await admin
      .firestore()
      .collection("users")
      .doc(uid)
      .collection("sec")
      .doc("wallet")
      .update({
        amount: admin.firestore.FieldValue.increment(-newAmount),
        total: admin.firestore.FieldValue.increment(-newAmount),
      });

    await admin
      .firestore()
      .collection("users")
      .doc(uid)
      .collection("transcations")
      .doc(referenceId)
      .set({
        referenceId: referenceId,
        amount: amount,
        orderId: "notrequired",
        type: "Participated in Poll",
        isDebit: true,
        time: currentTime,
      });

    await admin
      .firestore()
      .collection("users")
      .doc(uid)
      .collection("participatedpolls")
      .doc(questionId)
      .set({
        questionId: questionId,
        question: question,
        image: image,
        selectedAmount: amount,
        submittedTime: currentTime,
        selectedOption: selectedOption,
        secondOption: secondOption,
        secondOptionRequired: isSecondOption == "true" ? true : false,
        resultDeclared: false,
        youWon: false,
        winningAmount: 0,
        isLive: true,
        time: time,
        majority: "",
      });

    await admin
      .firestore()
      .collection("userranking")
      .doc(uid)
      .update({
        alltime: admin.firestore.FieldValue.increment(-newAmount),
        weekly: admin.firestore.FieldValue.increment(-newAmount),
      });

    await admin
      .firestore()
      .collection("questions")
      .doc(questionId)
      .collection("submissions")
      .doc(uid)
      .set({
        userid: uid,
        selectedAmount: amount,
        questionId: questionId,
        selectedOption: selectedOption,
        secondOption: secondOption,
        hasWon: false,
        winningamt: 0,
      });

    //Update question particpant & revenue generated
    await admin
      .firestore()
      .collection("questions")
      .doc(questionId)
      .get()
      .then((doc) => {
        if (!doc.exists) {
          console.log("no such doc");
        } else {
          admin
            .firestore()
            .collection("questions")
            .doc(questionId)
            .update({
              totalparticpants: admin.firestore.FieldValue.increment(+1),
            });
        }
      });

    //update QUESTION -> ANALTICS -> FIRSTQUESTION
    await admin
      .firestore()
      .collection("questions")
      .doc(questionId)
      .collection("analyticsdata")
      .doc("firstquestion")
      .get()
      .then((doc) => {
        if (!doc.exists) {
          console.log("no such doc");
        } else {
          console.log(doc.get(selectedOption));
          const newCount = doc.get(selectedOption) + 1;
          console.log(newCount);
          admin
            .firestore()
            .collection("questions")
            .doc(questionId)
            .collection("analyticsdata")
            .doc("firstquestion")
            .update({
              [selectedOption]: newCount,
            });
        }
      });

    res.status(200).send("success");
  } catch (error) {
    console.log(error);
    res.status(400).send(error);
  }
});

// ANCHOR - Payment Gateway 2nd Step

app.post("/updatepoll", async (req, res) => {
  const {
    uid,
    amount,
    questionId,
    question,
    image,
    selectedOption,
    isSecondOption,
    secondOption,
    referenceId,
    orderId,
    time,
  } = req.body;
  const currentTime = admin.firestore.FieldValue.serverTimestamp();

  // set user particapted poll for individual
  await admin
    .firestore()
    .collection("users")
    .doc(uid)
    .collection("participatedpolls")
    .doc(questionId)
    .set({
      questionId: questionId,
      question: question,
      image: image,
      selectedAmount: amount,
      submittedTime: currentTime,
      selectedOption: selectedOption,
      secondOption: secondOption,
      secondOptionRequired: isSecondOption == "true" ? true : false,
      resultDeclared: false,
      youWon: false,
      winningAmount: 0,
      isLive: true,
      time: time,
      majority: "",
    });

  await admin
    .firestore()
    .collection("questions")
    .doc(questionId)
    .collection("submissions")
    .doc(uid)
    .set({
      userid: uid,
      selectedAmount: amount,
      questionId: questionId,
      selectedOption: selectedOption,
      secondOption: secondOption,
      hasWon: false,
      winningamt: 0,
    });

  //update QUESTION -> ANALTICS -> FIRSTQUESTION
  // amount: admin.firestore.FieldValue.increment(userincome),

  await admin
    .firestore()
    .collection("questions")
    .doc(questionId)
    .collection("analyticsdata")
    .doc("firstquestion")
    .update({
      [selectedOption]: admin.firestore.FieldValue.increment(+1),
    });

  // await admin
  //   .firestore()
  //   .collection("questions")
  //   .doc(questionId)
  //   .collection("analyticsdata")
  //   .doc("firstquestion")
  //   .get()
  //   .then((doc) => {
  //     if (!doc.exists) {
  //       console.log("no such doc");
  //     } else {
  //       console.log(doc.get(selectedOption));
  //       const newCount = doc.get(selectedOption) + 1;
  //       console.log(newCount);
  //       admin
  //         .firestore()
  //         .collection("questions")
  //         .doc(questionId)
  //         .collection("analyticsdata")
  //         .doc("firstquestion")
  //         .update({
  //           [selectedOption]: newCount,
  //         });
  //     }
  //   });

  //update QUESTION -> ANALTICS -> FIRSTQUESTIONAMT
  await admin
    .firestore()
    .collection("questions")
    .doc(questionId)
    .collection("analyticsdata")
    .doc("firstquestionamt")
    .get()
    .then((doc) => {
      if (!doc.exists) {
        console.log("no such doc");
      } else {
        const newCount = doc.get(selectedOption) + parseInt(amount);
        console.log(newCount);
        admin
          .firestore()
          .collection("questions")
          .doc(questionId)
          .collection("analyticsdata")
          .doc("firstquestionamt")
          .update({
            [selectedOption]: newCount,
          });
      }
    });
  //Update question particpant & revenue generated
  await admin
    .firestore()
    .collection("questions")
    .doc(questionId)
    .get()
    .then((doc) => {
      if (!doc.exists) {
        console.log("no such doc");
      } else {
        console.log(doc.get("totalparticpants"));
        const newCount = doc.get("totalparticpants") + 1;

        const newrevenueCount = doc.get("rvg") + parseInt(amount);
        console.log(newCount);
        admin.firestore().collection("questions").doc(questionId).update({
          totalparticpants: newCount,
          rvg: newrevenueCount,
        });
      }
    });

  await admin
    .firestore()
    .collection("users")
    .doc(uid)
    .collection("transcations")
    .doc(referenceId)
    .set({
      referenceId: referenceId,
      amount: amount,
      orderId: orderId,
      type: "INSTANT",
      time: currentTime,
    });

  console.log("success");

  res.status(200).send("abc");
});

// ANCHOR Poll particpation via wallet
app.post("/updatepollwallet", async (req, res) => {
  const {
    uid,
    amount,
    questionId,
    question,
    image,
    selectedOption,
    isSecondOption,
    secondOption,
    orderId,
    time,
  } = req.body;
  const currentTime = admin.firestore.FieldValue.serverTimestamp();

  let availablebalance = 0;
  let responsemsg = "";

  const referenceId = Date.now().toString();

  await admin
    .firestore()
    .collection("users")
    .doc(uid)
    .collection("sec")
    .doc("wallet")
    .get()
    .then((doc) => {
      if (!doc.exists) {
        console.log("no such doc");
      } else {
        availablebalance = doc.data().total;
      }
    });

  if (availablebalance > amount) {
    console.log(availablebalance);
    await admin
      .firestore()
      .collection("users")
      .doc(uid)
      .collection("sec")
      .doc("wallet")
      .get()
      .then((doc) => {
        if (!doc.exists) {
          console.log("no such doc");
        } else {
          const promoamount = doc.data().promo;
          const normalamount = doc.data().amount;

          if (promoamount > amount) {
            const newpromo = doc.data().promo - amount;
            const newtotal = availablebalance - amount;

            admin
              .firestore()
              .collection("users")
              .doc(uid)
              .collection("sec")
              .doc("wallet")
              .update({
                total: newtotal,
                promo: newpromo,
              });

            admin
              .firestore()
              .collection("users")
              .doc(uid)
              .collection("transcations")
              .doc(referenceId)
              .set({
                referenceId: referenceId,
                amount: amount,
                orderId: "abcd",
                type: "Participated in Poll",
                isDebit: true,
                time: currentTime,
              });
          } else if (promoamount == 0) {
            const newamount = normalamount - amount;
            const newtotal = availablebalance - amount;

            admin
              .firestore()
              .collection("users")
              .doc(uid)
              .collection("sec")
              .doc("wallet")
              .update({
                amount: newamount,
                total: newtotal,
              });

            admin
              .firestore()
              .collection("users")
              .doc(uid)
              .collection("transcations")
              .doc(referenceId)
              .set({
                referenceId: referenceId,
                amount: amount,
                orderId: "abcd",
                type: "Participated in Poll",
                isDebit: true,
                time: currentTime,
              });
          } else {
            console.log(`promo ${promoamount}`);
            console.log(`amount ${amount}`);

            const updatedamount = amount - promoamount;
            console.log(`updated amount ${updatedamount}`);
            const newamount = normalamount - updatedamount;
            console.log(newamount);

            const newtotal = availablebalance - amount;
            console.log(newtotal);
            admin
              .firestore()
              .collection("users")
              .doc(uid)
              .collection("sec")
              .doc("wallet")
              .update({
                amount: newamount,
                total: newtotal,
                promo: 0,
              });

            admin
              .firestore()
              .collection("users")
              .doc(uid)
              .collection("transcations")
              .doc(referenceId)
              .set({
                referenceId: referenceId,
                amount: amount,
                orderId: "abcd",
                type: "Participated in Poll",
                isDebit: true,
                time: currentTime,
              });
          }
        }
      });

    await admin
      .firestore()
      .collection("users")
      .doc(uid)
      .collection("participatedpolls")
      .doc(questionId)
      .set({
        questionId: questionId,
        question: question,
        image: image,
        selectedAmount: amount,
        submittedTime: currentTime,
        selectedOption: selectedOption,
        secondOption: secondOption,
        secondOptionRequired: isSecondOption == "true" ? true : false,
        resultDeclared: false,
        youWon: false,
        winningAmount: 0,
        isLive: true,
        time: time,
        majority: "",
      });

    await admin
      .firestore()
      .collection("questions")
      .doc(questionId)
      .collection("submissions")
      .doc(uid)
      .set({
        userid: uid,
        selectedAmount: amount,
        questionId: questionId,
        selectedOption: selectedOption,
        secondOption: secondOption,
        hasWon: false,
        winningamt: 0,
      });

    //update QUESTION -> ANALTICS -> FIRSTQUESTION
    await admin
      .firestore()
      .collection("questions")
      .doc(questionId)
      .collection("analyticsdata")
      .doc("firstquestion")
      .get()
      .then((doc) => {
        if (!doc.exists) {
          console.log("no such doc");
        } else {
          console.log(doc.get(selectedOption));
          const newCount = doc.get(selectedOption) + 1;
          console.log(newCount);
          admin
            .firestore()
            .collection("questions")
            .doc(questionId)
            .collection("analyticsdata")
            .doc("firstquestion")
            .update({
              [selectedOption]: newCount,
            });
        }
      });

    //update QUESTION -> ANALTICS -> FIRSTQUESTIONAMT
    await admin
      .firestore()
      .collection("questions")
      .doc(questionId)
      .collection("analyticsdata")
      .doc("firstquestionamt")
      .get()
      .then((doc) => {
        if (!doc.exists) {
          console.log("no such doc");
        } else {
          const newCount = doc.get(selectedOption) + parseInt(amount);
          console.log(newCount);
          admin
            .firestore()
            .collection("questions")
            .doc(questionId)
            .collection("analyticsdata")
            .doc("firstquestionamt")
            .update({
              [selectedOption]: newCount,
            });
        }
      });
    //Update question particpant & revenue generated
    await admin
      .firestore()
      .collection("questions")
      .doc(questionId)
      .get()
      .then((doc) => {
        if (!doc.exists) {
          console.log("no such doc");
        } else {
          console.log(doc.get("totalparticpants"));
          const newCount = doc.get("totalparticpants") + 1;

          const newrevenueCount = doc.get("rvg") + parseInt(amount);
          console.log(newCount);
          admin.firestore().collection("questions").doc(questionId).update({
            totalparticpants: newCount,
            rvg: newrevenueCount,
          });
        }
      });

    await admin
      .firestore()
      .collection("users")
      .doc(uid)
      .collection("transcations")
      .doc(referenceId)
      .set({
        referenceId: referenceId,
        amount: amount,
        orderId: orderId,
        type: "INSTANT",
        isDebit: true,
        time: currentTime,
      });

    responsemsg = "success";
  } else {
    responsemsg = "less amount";
  }

  console.log(responsemsg);

  res.status(200).send("abc");
});

//ANCHOR Payment gateway first step

app.post("/payment", async (req, res) => {
  const body = req.body;
  console.log(body);
  var postData = {
    orderId: body.order,
    orderAmount: body.amount,
    orderCurrency: "INR",
  };

  let axiosConfig = {
    headers: {
      "x-client-id": "1886624990eff538d8589a4871266881",
      "x-client-secret": "1a208b29293c0de0e575dfe36b399425bac553ff",
    },
  };

  const response = await axios
    .post(
      "https://test.cashfree.com/api/v2/cftoken/order",
      postData,
      axiosConfig
    )
    .then((res) => {
      console.log("RESPONSE RECEIVED: ", res.data);

      return res.data;
    })

    .catch((err) => {
      console.log("AXIOS ERROR: ", err);
      success = "failed";
    });

  res.status(200).send(response);
});

//ANCHOR Get result of poll take 2

app.post("/getResult2", async (req, res) => {
  const { questionId } = req.body;
  let option = [];
  const currentTime = admin.firestore.FieldValue.serverTimestamp();

  let winningvalue = 0;
  let winner = "";
  let winnerdata = [];
  let questionrevenue = 0;
  let totalIncome = 0;
  let winningAmount = 0;
  let lossingAmount = 0; //amount generated from user selecting losing option
  let amountdisbursed = 0;
  let optionvalue = {};
  let totalparticpants = 0;

  // get all poll data & check which is the highest selected option

  const task1 = () => {
    return new Promise(function (res) {
      admin
        .firestore()
        .collection("questions")
        .doc(questionId)
        .get()
        .then((docs) => {
          if (!docs.exists) {
            console.log("no such doc");
          } else {
            option = docs.get("option");
            totalparticpants = docs.get("totalparticpants");
            console.log(option);
            res("completed task 1");
          }
        });
    });
  };
  const task2 = () => {
    return new Promise(function (res) {
      for (let i = 0; i < option.length; i++) {
        admin
          .firestore()
          .collection("questions")
          .doc(questionId)
          .collection("analyticsdata")
          .doc("firstquestion")
          .get()
          .then((docs) => {
            if (!docs.exists) {
              console.log("no such doc");
            } else {
              optionvalue[option[i]] = docs.get(option[i]);

              if (docs.get(option[i]) > winningvalue) {
                winner = option[i];
                winningvalue = docs.get(option[i]);
              }
              console.log(winner);
              res("completed task 2");
            }
          });
      }
    });
  };

  const task5 = () => {
    return new Promise(function (res) {
      admin
        .firestore()
        .collection("questions")
        .doc(questionId)
        .collection("submissions")
        .get()
        .then((docs) => {
          docs.forEach((doc) => {
            if (doc.data().selectedOption == winner) {
              const totalinvamt = doc.data().selectedAmount;
              console.log(`user invested amount: ${totalinvamt}`);

              console.log(optionvalue[doc.data().selectedOption]);

              const userincome = Math.floor(
                totalinvamt * 2 +
                  (optionvalue[doc.data().selectedOption] / totalparticpants) *
                    100
              );

              amountdisbursed = 0;
              console.log(userincome);

              let data = {
                userid: doc.id,
                userinvamt: totalinvamt,
                userincome: Math.floor(parseFloat(userincome)),
                isWinner: true,
              };
              winnerdata.push(data);
            } else {
              const totalinvamt = doc.data().selectedAmount;

              const userincome = Math.floor(
                (optionvalue[doc.data().selectedOption] / totalparticpants) *
                  100
              );
              let data = {
                userid: doc.id,
                userinvamt: totalinvamt,
                userincome: Math.floor(parseFloat(userincome)),
                isWinner: false,
              };
              winnerdata.push(data);
            }
          });

          res("completed task 5");
        });
    });
  };

  const myPromises = [task1, task2, task5];

  async function handlePromises() {
    for (let promise of myPromises) {
      const res = await promise();
      console.log(res);
    }
  }

  await handlePromises();

  res.status(200).json({
    Amounttobedisbursed: amountdisbursed,
    winnerdata: winnerdata,
  });
});

//ANCHOR submit result take 2
app.post("/submitResult2", async (req, res) => {
  const { questionId } = req.body;
  let option = [];

  let winningvalue = 0;
  let winner = "";
  let winnerdata = [];
  let totalparticpants = 0;

  const referenceId = Date.now().toString();
  let question = "";
  let optionvalue = {};

  const timestamp = admin.firestore.FieldValue.serverTimestamp();

  // get all poll data & check which is the highest selected option

  const task1 = () => {
    return new Promise(function (res) {
      admin
        .firestore()
        .collection("questions")
        .doc(questionId)
        .get()
        .then((docs) => {
          if (!docs.exists) {
            console.log("no such doc");
          } else {
            option = docs.get("option");
            question = docs.get("title");
            totalparticpants = docs.get("totalparticpants");

            console.log(option);
            res("completed task 1");
          }
        });
    });
  };

  const task6 = () => {
    return new Promise(function (res) {
      for (let i = 0; i < option.length; i++) {
        admin
          .firestore()
          .collection("questions")
          .doc(questionId)
          .collection("analyticsdata")
          .doc("firstquestion")
          .get()
          .then((docs) => {
            if (!docs.exists) {
              console.log("no such doc");
            } else {
              optionvalue[option[i]] = docs.get(option[i]);

              admin
                .firestore()
                .collection("questions")
                .doc(questionId)
                .collection("analyticsdata")
                .doc("chart")
                .update({ [option[i]]: docs.get(option[i]) });

              if (docs.get(option[i]) > winningvalue) {
                winner = option[i];
                winningvalue = docs.get(option[i]);
              }
            }
          });
      }

      res("task 6 completed (after task1)");
    });
  };

  const task2 = () => {
    return new Promise(function (res) {
      for (let i = 0; i < option.length; i++) {
        admin
          .firestore()
          .collection("questions")
          .doc(questionId)
          .collection("analyticsdata")
          .doc("firstquestion")
          .get()
          .then((docs) => {
            if (!docs.exists) {
              console.log("no such doc");
            } else {
              optionvalue[option[i]] = docs.get(option[i]);

              if (docs.get(option[i]) > winningvalue) {
                winner = option[i];
                winningvalue = docs.get(option[i]);
              }
              console.log(winner);
              res("completed task 2");
            }
          });
      }
    });
  };

  //  go through each particpated user of the poll

  const task5 = () => {
    return new Promise(function (res) {
      admin
        .firestore()
        .collection("questions")
        .doc(questionId)
        .collection("submissions")
        .get()
        .then((docs) => {
          docs.forEach((doc) => {
            if (doc.data().selectedOption == winner) {
              //9)if the particpant choose winner option check the total amount he invested
              const totalinvamt = doc.data().selectedAmount;

              const userincome = Math.floor(
                totalinvamt * 2 +
                  (optionvalue[doc.data().selectedOption] / totalparticpants) *
                    100
              );

              console.log(userincome);

              admin
                .firestore()
                .collection("users")
                .doc(doc.id)
                .collection("participatedpolls")
                .doc(questionId)
                .update({
                  youWon: true,
                  winningAmount: userincome,
                  resultDeclared: true,
                  isLive: false,
                  majority: winner,
                });

              admin
                .firestore()
                .collection("questions")
                .doc(questionId)
                .collection("submissions")
                .doc(doc.id)
                .update({
                  hasWon: true,
                  winningAmount: userincome,
                });

              admin
                .firestore()
                .collection("users")
                .doc(doc.id)
                .collection("sec")
                .doc("wallet")
                .update({
                  amount: admin.firestore.FieldValue.increment(userincome),
                  total: admin.firestore.FieldValue.increment(userincome),
                });

              admin
                .firestore()
                .collection("userranking")
                .doc(doc.id)
                .update({
                  alltime: admin.firestore.FieldValue.increment(userincome),
                  weekly: admin.firestore.FieldValue.increment(userincome),
                });

              admin
                .firestore()
                .collection("users")
                .doc(doc.id)
                .collection("transcations")
                .doc(referenceId)
                .set({
                  referenceId: referenceId,
                  amount: userincome.toString(),
                  orderId: "not required",
                  isDebit: false,
                  type: "WON POLL",
                  time: timestamp,
                });

              const notificationId = Date.now().toString();

              admin
                .firestore()
                .collection("users")
                .doc(doc.id)
                .collection("notifications")
                .doc(notificationId)
                .set({
                  notificationId: notificationId,
                  title: question,
                  type: "YOUWON",
                  questionId: questionId,
                  timestamp: timestamp,
                });
            } else {
              console.log(doc.id);

              const userincome = Math.floor(
                (optionvalue[doc.data().selectedOption] / totalparticpants) *
                  100
              );

              admin
                .firestore()
                .collection("questions")
                .doc(questionId)
                .collection("submissions")
                .doc(doc.id)
                .update({
                  hasWon: false,
                  winningAmount: userincome,
                });

              admin
                .firestore()
                .collection("users")
                .doc(doc.id)
                .collection("participatedpolls")
                .doc(questionId)
                .update({
                  youWon: false,
                  winningAmount: userincome,
                  resultDeclared: true,
                  isLive: false,
                  majority: winner,
                });

              const notificationId = Date.now().toString();

              admin
                .firestore()
                .collection("users")
                .doc(doc.id)
                .collection("transcations")
                .doc(referenceId)
                .set({
                  referenceId: referenceId,
                  amount: userincome.toString(),
                  orderId: "not required",
                  isDebit: false,
                  type: "LOST POLL",
                  time: timestamp,
                });

              admin
                .firestore()
                .collection("users")
                .doc(doc.id)
                .collection("notifications")
                .doc(notificationId)
                .set({
                  notificationId: notificationId,
                  title: question,
                  type: "YOULOSE",
                  questionId: questionId,
                  timestamp: timestamp,
                });
            }
          });

          res("completed task 5");
        });
    });
  };

  const myPromises = [task1, task6, task2, task5];

  async function handlePromises() {
    for (let promise of myPromises) {
      const res = await promise();
      console.log(res);
    }
  }

  await handlePromises();

  res.status(200).json("success");
});

//ANCHOR Poll Analysis for Chart

//poll chart

app.post("/getPollAnalysis", async (req, res) => {
  const { questionId } = req.body;
  let option = [];
  let response = [];
  await admin
    .firestore()
    .collection("questions")
    .doc(questionId)
    .get()
    .then((docs) => {
      if (!docs.exists) {
        console.log("no such doc");
      } else {
        option = docs.get("option");
      }
    });

  await admin
    .firestore()
    .collection("questions")
    .doc(questionId)
    .collection("analyticsdata")
    .doc("firstquestion")
    .get()
    .then((doc) => {
      if (!doc.exists) {
        console.log("no such doc");
      } else {
        for (let i = 0; i < option.length; i++) {
          let data = { x: option[i], y: doc.get(option[i]) };
          response.push(data);
        }
        console.log(response);
      }
    });

  res.status(200).send(response);
});

//ANCHOR Submit Question

app.post("/submitQuestion", async (req, res) => {
  const {
    questionId,
    option,
    title,
    expiredDate,
    image,
    category,
    isSecondQuestionreq,
    secondquestion,
  } = req.body;
  let optionamt = {};

  for (let i = 0; i < option.length; i++) {
    optionamt[option[i]] = 0;
  }

  const timestamp = admin.firestore.FieldValue.serverTimestamp();

  await admin.firestore().collection("questions").doc(questionId).set({
    questionid: questionId,
    CreatedAt: timestamp,
    title: title,
    expiredDate: expiredDate,
    totalparticpants: 0,
    image: image,
    rvg: 0,
    ti: 0,
    category: category,
    option: option,
    isSecondQuestionreq: isSecondQuestionreq,
    secondquestion: secondquestion,
    showResult: false,
    majority: "",
  });

  await admin
    .firestore()
    .collection("questions")
    .doc(questionId)
    .collection("analyticsdata")
    .doc("firstquestion")
    .set(optionamt);

  await admin
    .firestore()
    .collection("questions")
    .doc(questionId)
    .collection("analyticsdata")
    .doc("firstquestionamt")
    .set(optionamt);

  await admin
    .firestore()
    .collection("questions")
    .doc(questionId)
    .collection("analyticsdata")
    .doc("chart")
    .set(optionamt);

  res.status(200).send({
    questionId: [questionId],
    option: [option],
    optionamt: [optionamt],
  });
});

//ANCHOR Request Withdrawl

app.post("/requestwithdrawl", async (req, res) => {
  const { userId, phone, amount } = req.body;
  var current = new Date();

  const withdrawlId = Date.now().toString();
  let updatedWallet = 0;
  const currentTime = admin.firestore.FieldValue.serverTimestamp();

  //update wallet
  const proceed = await admin
    .firestore()
    .collection("users")
    .doc(userId)
    .collection("sec")
    .doc("wallet")
    .get()
    .then((docs) => {
      if (!docs.exists) {
        console.log("no such doc");
      } else {
        oldwallet = parseInt(docs.get("amount"));
        console.log(oldwallet);
        console.log(amount);

        if (oldwallet > parseInt(amount)) {
          updatedWallet = oldwallet - amount;
          console.log("please execute");
          return true;
        }
      }
    });

  if (proceed) {
    console.log("executig");
    await axios.post(
      "https://hooks.slack.com/services/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",
      {
        text: `Hi Team, New Withdrawl request ${userId} ${phone} ${amount} ${currentTime}`,
      }
    );

    await admin.firestore().collection("withdrawls").doc(withdrawlId).set({
      userId: userId,
      phone: phone,
      amount: amount,
      status: "pending",
      time: currentTime,
    });

    await admin
      .firestore()
      .collection("users")
      .doc(userId)
      .collection("withdrawls")
      .doc(withdrawlId)
      .set({
        amount: amount,
        status: "pending",
        time: currentTime,
        withdrawlid: withdrawlId,
      });

    await admin
      .firestore()
      .collection("users")
      .doc(userId)
      .collection("transcations")
      .doc(withdrawlId)
      .set({
        referenceId: withdrawlId,
        amount: amount,
        type: "WITHDRAWL",
        isDebit: true,
        time: currentTime,
      });

    await admin
      .firestore()
      .collection("users")
      .doc(userId)
      .collection("sec")
      .doc("wallet")
      .update({
        amount: admin.firestore.FieldValue.increment(-amount),
        total: admin.firestore.FieldValue.increment(-amount),
      });
  }

  res.send("success");
});

//ANCHOR Withdrawl done

app.post("/withdrawlprocessed", async (req, res) => {
  const { userId, withdrawlId } = req.body;
  var current = new Date();
  const currentTime = current.toLocaleString();

  console.log(withdrawlId);

  await admin
    .firestore()
    .collection("withdrawls")
    .doc(withdrawlId.toString())
    .update({
      status: "processed",
      time: currentTime,
    });

  await admin
    .firestore()
    .collection("users")
    .doc(userId.toString())
    .collection("withdrawls")
    .doc(withdrawlId.toString())
    .update({
      status: "processed",
      time: currentTime,
    });

  res.send("success");
});

//ANCHOR Pan Card Verifiication

app.post("/verification", async (req, res) => {
  const { userId, name, pannumber } = req.body;
  var current = new Date();
  const currentTime = current.toLocaleString();
  let isVerified;

  //update pancard
  const proceed = await admin
    .firestore()
    .collection("users")
    .doc(userId)
    .collection("sec")
    .doc("pancard")
    .get()
    .then((docs) => {
      if (!docs.exists) {
        return true;
      } else {
        return false;
      }
    });

  if (proceed) {
    await axios.post(
      " https://api.cashfree.com/verification/pan",
      {
        name: name,
        pan: pannumber,
      },
      {
        headers: {
          "x-client-id": "",
          "x-client-secret": "",
          "Content-Type": "application/json",
        },
      }
    );

    await admin
      .firestore()
      .collection("users")
      .doc(userId)
      .collection("sec")
      .doc("pancard")
      .set({
        name: name,
        pan: pannumber,
        verified: true,
        time: currentTime,
      });
  }

  res.send("success");
});

//ANCHOR updateleader board

app.post("/updateleaderboard", async (req, res) => {
  var allTimeArray = new Array();
  var weeklyArray = new Array();
  const currentTime = admin.firestore.FieldValue.serverTimestamp();

  allTimeArray[0] = {};
  allTimeArray[1] = {};
  allTimeArray[2] = {};
  allTimeArray[3] = {};
  allTimeArray[4] = {};
  allTimeArray[5] = {};
  allTimeArray[6] = {};
  allTimeArray[7] = {};
  allTimeArray[8] = {};
  allTimeArray[9] = {};

  weeklyArray[0] = {};
  weeklyArray[1] = {};
  weeklyArray[2] = {};
  weeklyArray[3] = {};
  weeklyArray[4] = {};
  weeklyArray[5] = {};
  weeklyArray[6] = {};
  weeklyArray[7] = {};
  weeklyArray[8] = {};
  weeklyArray[9] = {};

  const task1 = () => {
    return new Promise(function (res) {
      let weeklyhigh = 0;
      let alltimehigh = 0;

      admin
        .firestore()
        .collection("userranking")
        .get()
        .then((docs) => {
          docs.forEach((doc) => {
            const id = doc.id;
            const alltime = doc.data().alltime;
            const weekly = doc.data().weekly;
            const name = doc.data().name;
            const image = doc.data().image;

            if (alltime > alltimehigh) {
              alltimehigh = alltime;
              allTimeArray[0] = {
                id,
                alltime,
                name,
                image,
              };
            }
            if (weekly > weeklyhigh) {
              weeklyhigh = weekly;
              weeklyArray[0] = {
                id,
                weekly,
                name,
                image,
              };
            }
          });
          res("completed task 1");
        });
    });
  };

  const task2 = () => {
    return new Promise(function (res) {
      let weeklyhigh = 0;
      let alltimehigh = 0;

      admin
        .firestore()
        .collection("userranking")
        .get()
        .then((docs) => {
          docs.forEach((doc) => {
            const id = doc.id;
            const alltime = doc.data().alltime;
            const weekly = doc.data().weekly;
            const name = doc.data().name;
            const image = doc.data().image;

            if (
              alltime > alltimehigh &&
              alltime <= allTimeArray[0].alltime &&
              id != allTimeArray[0].id
            ) {
              alltimehigh = alltime;
              allTimeArray[1] = {
                id,
                alltime,
                name,
                image,
              };
            }

            if (
              weekly > weeklyhigh &&
              weekly <= weeklyArray[0].weekly &&
              id != weeklyArray[0].id
            ) {
              weeklyhigh = weekly;
              weeklyArray[1] = {
                id,
                weekly,
                name,
                image,
              };
            }
          });
          res("completed task 2");
        });
    });
  };

  const task3 = () => {
    return new Promise(function (res) {
      let weeklyhigh = 0;
      let alltimehigh = 0;

      admin
        .firestore()
        .collection("userranking")
        .get()
        .then((docs) => {
          docs.forEach((doc) => {
            const id = doc.id;
            const alltime = doc.data().alltime;
            const weekly = doc.data().weekly;
            const name = doc.data().name;
            const image = doc.data().image;

            if (
              alltime > alltimehigh &&
              alltime <= allTimeArray[1].alltime &&
              id != allTimeArray[1].id &&
              id != allTimeArray[0].id
            ) {
              alltimehigh = alltime;
              allTimeArray[2] = {
                id,
                alltime,
                name,
                image,
              };
            }

            if (
              weekly > weeklyhigh &&
              weekly <= weeklyArray[1].weekly &&
              id != weeklyArray[1].id &&
              id != weeklyArray[0].id
            ) {
              weeklyhigh = weekly;
              weeklyArray[2] = {
                id,
                weekly,
                name,
                image,
              };
            }
          });
          res("completed task 3");
        });
    });
  };

  const task4 = () => {
    return new Promise(function (res) {
      let weeklyhigh = 0;
      let alltimehigh = 0;

      admin
        .firestore()
        .collection("userranking")
        .get()
        .then((docs) => {
          docs.forEach((doc) => {
            const id = doc.id;
            const alltime = doc.data().alltime;
            const weekly = doc.data().weekly;
            const name = doc.data().name;
            const image = doc.data().image;

            if (
              alltime > alltimehigh &&
              alltime <= allTimeArray[2].alltime &&
              id != allTimeArray[2].id &&
              id != allTimeArray[1].id &&
              id != allTimeArray[0].id
            ) {
              alltimehigh = alltime;
              allTimeArray[3] = {
                id,
                alltime,
                name,
                image,
              };
            }

            if (
              weekly > weeklyhigh &&
              weekly <= weeklyArray[2].weekly &&
              id != weeklyArray[2].id &&
              id != weeklyArray[1].id &&
              id != weeklyArray[0].id
            ) {
              weeklyhigh = weekly;
              weeklyArray[3] = {
                id,
                weekly,
                name,
                image,
              };
            }
          });
          res("completed task 4");
        });
    });
  };

  const task5 = () => {
    return new Promise(function (res) {
      let weeklyhigh = 0;
      let alltimehigh = 0;

      admin
        .firestore()
        .collection("userranking")
        .get()
        .then((docs) => {
          docs.forEach((doc) => {
            const id = doc.id;
            const alltime = doc.data().alltime;
            const weekly = doc.data().weekly;
            const name = doc.data().name;
            const image = doc.data().image;

            console.log(id);
            console.log(alltime);

            if (
              alltime > alltimehigh &&
              alltime <= allTimeArray[3].alltime &&
              id != allTimeArray[3].id &&
              id != allTimeArray[2].id &&
              id != allTimeArray[1].id &&
              id != allTimeArray[0].id
            ) {
              alltimehigh = alltime;
              allTimeArray[4] = {
                id,
                alltime,
                name,
                image,
              };
            }

            if (
              weekly > weeklyhigh &&
              weekly <= weeklyArray[3].weekly &&
              id != weeklyArray[3].id &&
              id != weeklyArray[2].id &&
              id != weeklyArray[1].id &&
              id != weeklyArray[0].id
            ) {
              weeklyhigh = weekly;
              weeklyArray[4] = {
                id,
                weekly,
                name,
                image,
              };
            }
          });
          res("completed task 5");
        });
    });
  };

  const task6 = () => {
    return new Promise(function (res) {
      let weeklyhigh = 0;
      let alltimehigh = 0;

      admin
        .firestore()
        .collection("userranking")
        .get()
        .then((docs) => {
          docs.forEach((doc) => {
            const id = doc.id;
            const alltime = doc.data().alltime;
            const weekly = doc.data().weekly;
            const name = doc.data().name;
            const image = doc.data().image;

            console.log(id);
            console.log(alltime);

            if (
              alltime > alltimehigh &&
              alltime <= allTimeArray[4].alltime &&
              id != allTimeArray[4].id &&
              id != allTimeArray[3].id &&
              id != allTimeArray[2].id &&
              id != allTimeArray[1].id &&
              id != allTimeArray[0].id
            ) {
              alltimehigh = alltime;
              allTimeArray[5] = {
                id,
                alltime,
                name,
                image,
              };
            }

            if (
              weekly > weeklyhigh &&
              weekly <= weeklyArray[4].weekly &&
              id != weeklyArray[4].id &&
              id != weeklyArray[3].id &&
              id != weeklyArray[2].id &&
              id != weeklyArray[1].id &&
              id != weeklyArray[0].id
            ) {
              weeklyhigh = weekly;
              weeklyArray[5] = {
                id,
                weekly,
                name,
                image,
              };
            }
          });
          res("completed task 6");
        });
    });
  };

  const task7 = () => {
    return new Promise(function (res) {
      let weeklyhigh = 0;
      let alltimehigh = 0;

      admin
        .firestore()
        .collection("userranking")
        .get()
        .then((docs) => {
          docs.forEach((doc) => {
            const id = doc.id;
            const alltime = doc.data().alltime;
            const weekly = doc.data().weekly;
            const name = doc.data().name;
            const image = doc.data().image;

            console.log(id);
            console.log(alltime);

            if (
              alltime > alltimehigh &&
              alltime <= allTimeArray[5].alltime &&
              id != allTimeArray[5].id &&
              id != allTimeArray[4].id &&
              id != allTimeArray[3].id &&
              id != allTimeArray[2].id &&
              id != allTimeArray[1].id &&
              id != allTimeArray[0].id
            ) {
              alltimehigh = alltime;
              allTimeArray[6] = {
                id,
                alltime,
                name,
                image,
              };
            }

            if (
              weekly > weeklyhigh &&
              weekly <= weeklyArray[5].weekly &&
              id != weeklyArray[5].id &&
              id != weeklyArray[4].id &&
              id != weeklyArray[3].id &&
              id != weeklyArray[2].id &&
              id != weeklyArray[1].id &&
              id != weeklyArray[0].id
            ) {
              weeklyhigh = weekly;
              weeklyArray[6] = {
                id,
                weekly,
                name,
                image,
              };
            }
          });
          res("completed task 7");
        });
    });
  };

  const task8 = () => {
    return new Promise(function (res) {
      let weeklyhigh = 0;
      let alltimehigh = 0;

      admin
        .firestore()
        .collection("userranking")
        .get()
        .then((docs) => {
          docs.forEach((doc) => {
            const id = doc.id;
            const alltime = doc.data().alltime;
            const weekly = doc.data().weekly;
            const name = doc.data().name;
            const image = doc.data().image;

            console.log(id);
            console.log(alltime);

            if (
              alltime > alltimehigh &&
              alltime <= allTimeArray[6].alltime &&
              id != allTimeArray[6].id &&
              id != allTimeArray[5].id &&
              id != allTimeArray[4].id &&
              id != allTimeArray[3].id &&
              id != allTimeArray[2].id &&
              id != allTimeArray[1].id &&
              id != allTimeArray[0].id
            ) {
              alltimehigh = alltime;
              allTimeArray[7] = {
                id,
                alltime,
                name,
                image,
              };
            }

            if (
              weekly > weeklyhigh &&
              weekly <= weeklyArray[6].weekly &&
              id != weeklyArray[6].id &&
              id != weeklyArray[5].id &&
              id != weeklyArray[4].id &&
              id != weeklyArray[3].id &&
              id != weeklyArray[2].id &&
              id != weeklyArray[1].id &&
              id != weeklyArray[0].id
            ) {
              weeklyhigh = weekly;
              weeklyArray[7] = {
                id,
                weekly,
                name,
                image,
              };
            }
          });
          res("completed task 8");
        });
    });
  };

  const task9 = () => {
    return new Promise(function (res) {
      let weeklyhigh = 0;
      let alltimehigh = 0;

      admin
        .firestore()
        .collection("userranking")
        .get()
        .then((docs) => {
          docs.forEach((doc) => {
            const id = doc.id;
            const alltime = doc.data().alltime;
            const weekly = doc.data().weekly;
            const name = doc.data().name;
            const image = doc.data().image;

            if (
              alltime > alltimehigh &&
              alltime <= allTimeArray[7].alltime &&
              id != allTimeArray[7].id &&
              id != allTimeArray[6].id &&
              id != allTimeArray[5].id &&
              id != allTimeArray[4].id &&
              id != allTimeArray[3].id &&
              id != allTimeArray[2].id &&
              id != allTimeArray[1].id &&
              id != allTimeArray[0].id
            ) {
              alltimehigh = alltime;
              allTimeArray[8] = {
                id,
                alltime,
                name,
                image,
              };
            }

            if (
              weekly > weeklyhigh &&
              weekly <= weeklyArray[7].weekly &&
              id != weeklyArray[7].id &&
              id != weeklyArray[6].id &&
              id != weeklyArray[5].id &&
              id != weeklyArray[4].id &&
              id != weeklyArray[3].id &&
              id != weeklyArray[2].id &&
              id != weeklyArray[1].id &&
              id != weeklyArray[0].id
            ) {
              weeklyhigh = weekly;
              weeklyArray[8] = {
                id,
                weekly,
                name,
                image,
              };
            }
          });
          res("completed task 9");
        });
    });
  };

  const task10 = () => {
    return new Promise(function (res) {
      let weeklyhigh = 0;
      let alltimehigh = 0;

      admin
        .firestore()
        .collection("userranking")
        .get()
        .then((docs) => {
          docs.forEach((doc) => {
            const id = doc.id;
            const alltime = doc.data().alltime;
            const weekly = doc.data().weekly;
            const name = doc.data().name;
            const image = doc.data().image;

            if (
              alltime > alltimehigh &&
              alltime <= allTimeArray[8].alltime &&
              id != allTimeArray[8].id &&
              id != allTimeArray[7].id &&
              id != allTimeArray[6].id &&
              id != allTimeArray[5].id &&
              id != allTimeArray[4].id &&
              id != allTimeArray[3].id &&
              id != allTimeArray[2].id &&
              id != allTimeArray[1].id &&
              id != allTimeArray[0].id
            ) {
              alltimehigh = alltime;
              allTimeArray[9] = {
                id,
                alltime,
                name,
                image,
              };
            }

            if (
              weekly > weeklyhigh &&
              weekly <= weeklyArray[8].weekly &&
              id != weeklyArray[8].id &&
              id != weeklyArray[7].id &&
              id != weeklyArray[6].id &&
              id != weeklyArray[5].id &&
              id != weeklyArray[4].id &&
              id != weeklyArray[3].id &&
              id != weeklyArray[2].id &&
              id != weeklyArray[1].id &&
              id != weeklyArray[0].id
            ) {
              weeklyhigh = weekly;
              weeklyArray[9] = {
                id,
                weekly,
                name,
                image,
              };
            }
          });
          res("completed task 10");
        });
    });
  };

  const task11 = () => {
    return new Promise(function (res) {
      for (let i = 0; i < 10; i++) {
        admin
          .firestore()
          .collection("ranking")
          .doc("alltime")
          .update({
            [`${i + 1}.name`]: allTimeArray[i].name,
            [`${i + 1}.point`]: allTimeArray[i].alltime,
            [`${i + 1}.uid`]: allTimeArray[i].id,
            [`${i + 1}.image`]: allTimeArray[i].image,
            lastupdate: currentTime,
          });
        admin
          .firestore()
          .collection("ranking")
          .doc("weekly")
          .update({
            [`${i + 1}.name`]: weeklyArray[i].name,
            [`${i + 1}.point`]: weeklyArray[i].weekly,
            [`${i + 1}.uid`]: weeklyArray[i].id,
            [`${i + 1}.image`]: weeklyArray[i].image,
            lastupdate: currentTime,
          });
      }
    });
  };

  const myPromises = [
    task1,
    task2,
    task3,
    task4,
    task5,
    task6,
    task7,
    task8,
    task9,
    task10,
    task11,
  ];

  async function handlePromises() {
    for (let promise of myPromises) {
      const res = await promise();
      console.log(res);
    }
  }

  await handlePromises();

  res.status(200).send("success");
});

//ANCHOR set referral data

app.post("/setReferrer", async (req, res) => {
  const { referCode, uid } = req.body;

  let success = "";

  let validrefercode = false;

  await admin
    .firestore()
    .collection("users")
    .get()
    .then((docs) => {
      docs.forEach((doc) => {
        if (doc.data().code == referCode && doc.id != uid) {
          admin
            .firestore()
            .collection("users")
            .doc(uid)
            .collection("sec")
            .doc("wallet")
            .update({
              amount: admin.firestore.FieldValue.increment(30),
              total: admin.firestore.FieldValue.increment(30),
            });

          admin
            .firestore()
            .collection("userranking")
            .doc(uid)
            .set({
              alltime: admin.firestore.FieldValue.increment(30),
              weekly: admin.firestore.FieldValue.increment(30),
            });
          admin
            .firestore()
            .collection("userranking")
            .doc(doc.id)
            .set({
              alltime: admin.firestore.FieldValue.increment(30),
              weekly: admin.firestore.FieldValue.increment(30),
            });
          admin
            .firestore()
            .collection("users")
            .doc(doc.id)
            .collection("sec")
            .doc("wallet")
            .update({
              amount: admin.firestore.FieldValue.increment(30),
              total: admin.firestore.FieldValue.increment(30),
            });

          admin.firestore().collection("users").doc(uid).update({
            firstlogin: true,
            referrer: doc.id,
          });

          admin
            .firestore()
            .collection("users")
            .doc(doc.id)
            .collection("referalls")
            .doc(uid)
            .set({
              id: uid,
              amount: 30,
            });

          validrefercode = true;
        }

        if (validrefercode) {
          success = "validrefercode";
        } else {
          success = "refercodenotvalid";
        }
      });
    });

  res.status(200).send(success);
});

exports.ipoll = functions.region("asia-south1").https.onRequest(app);
