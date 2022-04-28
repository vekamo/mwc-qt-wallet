import QtQuick 2.12
import QtQuick.Controls 2.13
import QtQuick.Window 2.0
import ConfigBridge 1.0
import QtQuick.Layouts 1.15
import "./models"

Item {
    id: control
    property var contactList: []
    property string prevCBName
    property string prevCBAddress

    ConfigBridge {
        id: config
    }

    function updateContactsList() {
        const pairs = config.getContactsAsPairs()
        contactsModel.clear()
        contactList = []
        for (let i = 0; i < pairs.length; i += 2) {
            contactList.push({
                name: pairs[i],
                address: pairs[i+1]
            })
            contactsModel.append(contactList[contactList.length - 1])
        }
    }

    function onAddContact(ok, name, address) {
        if (ok) {
            const res = config.addContact(name, address)
            if (res !== "") {
                messagebox.open(qsTr("Error"), qsTr("Unable to add a new contact.\n" + res))
            }
            updateContactsList()
        }
    }

    function onEditContact(ok, name, address) {
        if (ok) {
            const res = config.updateContact(prevCBName, prevCBAddress, name, address)
            if (res !== "") {
                messagebox.open(qsTr("Error"), qsTr("Unable to update the contact data. Error: " + res))
            }
            updateContactsList()
        }
    }

    function onDeleteContact(ok) {
        if (ok) {
            const res = config.deleteContact(prevCBName, prevCBAddress)
            if (res !== "") {
                messagebox.open(qsTr("Error"), qsTr("Unable to remove the contact '"+ prevCBName +"'.\nError: " + res))
            }
            updateContactsList()
        }
    }

    function weakHash(string) {
        let sum = 0;
        for (let i = 0; i < string.length; i++)
            sum += (i + 1) * string.codePointAt(i) / (1 << 8)
        let res = sum % 1
        return Math.floor(res*100000000000000000000000).toString(16).substring(0,6)
    }


    onVisibleChanged: {
        if (visible) {
            updateContactsList()
        }
    }

    SearchField {
        id: searchField
        height: dp(45)
        placeHolder: qsTr("Search contacts")
        width: parent.width*0.65
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: parent.width*0.05
    }

    Rectangle {
        id: rec
        height: searchField.height
        width: parent.width*0.25
        radius: dp(10)
        color: "#00000000"
        anchors.left: searchField.right
        anchors.leftMargin: searchField.anchors.leftMargin/2
        anchors.verticalCenter: searchField.verticalCenter
        ImageColor {
            id: img_new
            img_height: parent.height/2.5
            img_source: "../../img/plus.svg"
            img_color: "gray"
            anchors.left: control.left
            anchors.leftMargin: dp(10)
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            id: loginText
            text: qsTr("New Contact")
            anchors.left: img_new.right
            anchors.leftMargin: dp(5)
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: dp(13)
            color: "white"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: editDlg.open("", "", contactList, false, onAddContact)
        }
    }

    ListModel {
        id: contactsModel
    }


    Rectangle {
        width: parent.width
        color: dark.bgGradientBottom
        anchors.top: searchField.bottom
        anchors.topMargin: dp(25)
        anchors.bottom: parent.bottom
        ListView {
            id: contactsList
            anchors.fill: parent
            model: contactsModel
            delegate: contactsDelegate
            clip: true
            focus: true
        }
    }





    Component {
        id: contactsDelegate
        Rectangle {
            height: rectangle.height + dp(20)
            color: "#00000000"
            width: control.width

            Rectangle {
                id: rectangle
                height: text_address.height + text_name.height + dp(25)
                width: parent.width*0.9
                color: "#33bf84ff"
                radius: dp(15)
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    id: initial_logo
                    height: parent.height*0.5
                    width: height
                    radius: dp(150)
                    color: "#%1".arg(weakHash(address))
                    anchors.left: parent.left
                    anchors.leftMargin: dp(20)
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        color: "#ffffff"
                        text: name.charAt(0)
                        font.bold: true
                        font.pixelSize: initial_logo.height*0.6
                        font.capitalization: Font.AllUppercase
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }


                Text {
                    id: text_name
                    color: "#ffffff"
                    text: name
                    font.pixelSize: dp(18)
                    font.bold: true
                    anchors.top: parent.top
                    anchors.topMargin: dp(10)
                    anchors.left: initial_logo.right
                    anchors.leftMargin: dp(20)


                }
                TextEdit {
                    id: text_address
                    readOnly: true
                    font.pixelSize: dp(15)
                    anchors.top: text_name.bottom
                    anchors.topMargin: dp(2)
                    anchors.left: initial_logo.right
                    anchors.leftMargin: dp(20)
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width*0.15
                    wrapMode: Text.WrapAnywhere
                    color: "white"
                    text: address
                }

                Rectangle {
                    id: icon_layout
                    height: parent.height*0.8
                    anchors.verticalCenter: parent.verticalCenter
                    width: rectangle.width/7
                    anchors.right: parent.right
                    color: "#00000000"

                    ColumnLayout {
                        Layout.topMargin: dp(10)
                        Layout.bottomMargin: dp(10)
                        height: parent.height
                        width: parent.width

                        ImageColor {
                            id: img_qr
                            img_width: icon_layout.height/4
                            img_source: "../../img/qr.svg"
                            img_color: "white"
                            Layout.preferredHeight: icon_layout.height/4
                            Layout.preferredWidth: icon_layout.width
                            Layout.alignment: Qt.AlignCenter
                        }

                        ImageColor {
                            id: img_edit
                            img_width: icon_layout.height/4
                            img_source: "../../img/edit.svg"
                            img_color: "white"
                            Layout.preferredHeight: icon_layout.height/4
                            Layout.preferredWidth: icon_layout.width
                            Layout.alignment: Qt.AlignCenter
                        }

                        ImageColor {
                            id: img_delete
                            img_width: icon_layout.height/4
                            img_source: "../../img/edit.svg"
                            img_color: "white"
                            Layout.preferredHeight: icon_layout.height/4
                            Layout.preferredWidth: icon_layout.width
                            Layout.alignment: Qt.AlignCenter
                        }
                    }

                }



                /*T
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            const newContactList = contactList.filter(contact => contact.name !== name)
                            prevCBName = name
                            prevCBAddress = address
                            editDlg.open(name, address, newContactList, true, onEditContact)
                        }
                    }
                }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            prevCBName = name
                            prevCBAddress = address
                            messagebox.open("Remove a contact", "Are you sure, you want to remove the contact " + name + "?", true, "No", "Yes", "", "", "", onDeleteContact)
                        }
                    }
                }*/
            }
        }
    }

    /*Rectangle {
        id: rect_buttons
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: dp(10)
        height: dp(50)
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0
                color: "#9E00E7"
            }

            GradientStop {
                position: 1
                color: "#3600C9"
            }
        }

        Rectangle {
            width: dp(250)
            height: dp(40)
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#00000000"

            Image {
                id: image_add
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: dp(40)
                height: dp(40)
                fillMode: Image.PreserveAspectFit
                source: "../img/Add@2x.svg"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        editDlg.open("", "", contactList, false, onAddContact)
                    }
                }
            }
        }
    }*/
}
