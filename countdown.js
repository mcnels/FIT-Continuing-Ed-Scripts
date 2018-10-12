// ************************************************************************************
// ** This file has been created with the Rotating Content Tool by Amesbury Web.     **
// ** For more information, visit us on the web:                                     **
// **                                                                                **
// **     Rotating Content Tool   -- http://rotatecontent.com/                       **
// **     Company: Amesbury Web   -- http://amesburyweb.com/                         **
// **     Author:  Randy Hoyt     -- http://randyhoyt.com/                           **
// **                                                                                **
// ************************************************************************************

today = new Date()
month = today.getMonth() + 1
year = today.getFullYear()

selectedDate = new Date("01/01/1900")
selectedContent = ""

varLength = 30
var entryDate = new Array(varLength)
var entryContent = new Array(varLength)

entryDate[0] = "10/02/2018"
entryContent[0] = "<img src=\"http://rotatecontent.com/progress/xpgreen000.gif\">"

entryDate[1] = " 10/03/2018"
entryContent[1] = "<img src=\"http://rotatecontent.com/progress/xpgreen001.gif\">"

entryDate[2] = " 10/04/2018"
entryContent[2] = "<img src=\"http://rotatecontent.com/progress/xpgreen003.gif\">"

entryDate[3] = " 10/05/2018"
entryContent[3] = "<img src=\"http://rotatecontent.com/progress/xpgreen005.gif\">"

entryDate[4] = " 10/06/2018"
entryContent[4] = "<img src=\"http://rotatecontent.com/progress/xpgreen007.gif\">"

entryDate[5] = " 10/07/2018"
entryContent[5] = "<img src=\"http://rotatecontent.com/progress/xpgreen008.gif\">"

entryDate[6] = " 10/08/2018"
entryContent[6] = "<img src=\"http://rotatecontent.com/progress/xpgreen010.gif\">"

entryDate[7] = " 10/09/2018"
entryContent[7] = "<img src=\"http://rotatecontent.com/progress/xpgreen012.gif\">"

entryDate[8] = " 10/10/2018"
entryContent[8] = "<img src=\"http://rotatecontent.com/progress/xpgreen014.gif\">"

entryDate[9] = " 10/11/2018"
entryContent[9] = "<img src=\"http://rotatecontent.com/progress/xpgreen016.gif\">"

entryDate[10] = " 10/12/2018"
entryContent[10] = "<img src=\"http://rotatecontent.com/progress/xpgreen017.gif\">"

entryDate[11] = " 10/13/2018"
entryContent[11] = "<img src=\"http://rotatecontent.com/progress/xpgreen019.gif\">"

entryDate[12] = " 10/14/2018"
entryContent[12] = "<img src=\"http://rotatecontent.com/progress/xpgreen021.gif\">"

entryDate[13] = " 10/15/2018"
entryContent[13] = "<img src=\"http://rotatecontent.com/progress/xpgreen023.gif\">"

entryDate[14] = " 10/16/2018"
entryContent[14] = "<img src=\"http://rotatecontent.com/progress/xpgreen025.gif\">"

entryDate[15] = " 10/17/2018"
entryContent[15] = "<img src=\"http://rotatecontent.com/progress/xpgreen026.gif\">"

entryDate[16] = " 10/18/2018"
entryContent[16] = "<img src=\"http://rotatecontent.com/progress/xpgreen028.gif\">"

entryDate[17] = " 10/19/2018"
entryContent[17] = "<img src=\"http://rotatecontent.com/progress/xpgreen030.gif\">"

entryDate[18] = " 10/20/2018"
entryContent[18] = "<img src=\"http://rotatecontent.com/progress/xpgreen032.gif\">"

entryDate[19] = " 10/21/2018"
entryContent[19] = "<img src=\"http://rotatecontent.com/progress/xpgreen034.gif\">"

entryDate[20] = " 10/22/2018"
entryContent[20] = "<img src=\"http://rotatecontent.com/progress/xpgreen035.gif\">"

entryDate[21] = " 10/23/2018"
entryContent[21] = "<img src=\"http://rotatecontent.com/progress/xpgreen037.gif\">"

entryDate[22] = " 10/24/2018"
entryContent[22] = "<img src=\"http://rotatecontent.com/progress/xpgreen039.gif\">"

entryDate[23] = " 10/25/2018"
entryContent[23] = "<img src=\"http://rotatecontent.com/progress/xpgreen041.gif\">"

entryDate[24] = " 10/26/2018"
entryContent[24] = "<img src=\"http://rotatecontent.com/progress/xpgreen043.gif\">"

entryDate[25] = " 10/27/2018"
entryContent[25] = "<img src=\"http://rotatecontent.com/progress/xpgreen044.gif\">"

entryDate[26] = " 10/28/2018"
entryContent[26] = "<img src=\"http://rotatecontent.com/progress/xpgreen046.gif\">"

entryDate[27] = " 10/29/2018"
entryContent[27] = "<img src=\"http://rotatecontent.com/progress/xpgreen048.gif\">"

entryDate[28] = " 10/30/2018"
entryContent[28] = "<img src=\"http://rotatecontent.com/progress/xpgreen050.gif\">"

entryDate[29] = " 10/31/2018"
entryContent[29] = "<img src=\"http://rotatecontent.com/progress/xpgreen052.gif\">"

if (typeof display == "undefined") { var display = "date" }

if (display == "random")
{
  var randomNumber = Math.random()
  randomNumber *= varLength
  randomNumber = parseInt(randomNumber)
  if(isNaN(randomNumber)) randomNumber = 0
  else randomNumber %= varLength
  selectedContent = entryContent[randomNumber]
}
else
{
  for (x=0; x<(entryContent.length); x++)
  {
    tempDate = new Date(entryDate[x])
    tempContent = entryContent[x]
    if ((tempDate <= today) && (tempDate > selectedDate))
    {
      selectedContent = tempContent
      selectDate = tempDate
    }
  }
}

document.write (selectedContent)
