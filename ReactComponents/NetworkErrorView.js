'use strict';

import React, {
  StyleSheet,
  Text,
  Image,
  TouchableHighlight,
  View
} from 'react-native';

var Style = require('./Style.js');

var NetworkErrorView = React.createClass({
  render: function() {
    return (
      <View style={styles.container}>
        <TouchableHighlight onPress={this.props.retryHandler}>

        <View style={styles.button}>
          <Image
            style={styles.image}
            source={{uri: 'Fail Icon'}}
          />  
          <Text style={[Style.textHeading, styles.text]}>
            {this.props.title}
          </Text>
          <Text style={[Style.textBody, styles.text]}>
            {this.props.errorMessage}
          </Text>
          <Text style={[Style.textCaption, styles.text, {marginTop: 44}]}>
            Please tap to retry
          </Text>
        </View>
        </TouchableHighlight>   
      </View>
    );
  },
});

var styles = React.StyleSheet.create({
  container: {
    flex: 1,  
    justifyContent: 'center',
    backgroundColor: '#FFF',
  },
  button: {
    backgroundColor: '#FFF',
    padding: 16,
    alignItems: 'center',
  },
  image: {
    flex: 1,
    height: 65,
    width: 65,
    resizeMode: 'contain',
    alignItems: 'center',
    margin: 16,
  },
  text: {
    textAlign: 'center',
  }
});

module.exports = NetworkErrorView;