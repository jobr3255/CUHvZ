import React from "react";

interface FormattedTextProps {
  text: string
}

interface FormattedTextState {
  text: any[]
}

export default class FormattedText extends React.Component<FormattedTextProps, FormattedTextState> {

  constructor(props: FormattedTextProps) {
    super(props);
    this.state = {
      text: []
     };
  }

  componentDidMount() {
    var formattedText = this.formatData(this.props.text);
    this.setState({
      text: formattedText
    });
  }

  formatData(data: string) {
    var formattedText = new Array();
    // formats <br> tags where there are line breaks
    var brDel = "^\n";
    // formats BOLD[content] into an strong tag
    var boldDel = "BOLD\\[.*\\]";
    // formats LINK[name][link] into an html link
    var linkDel = "LINK(\\[.*\\]){2}";
    // formats LINK_NEW_TAB[name][link] into an html link
    var linkTabDil = "LINK_NEW_TAB(\\[.*\\]){2}";
    // formats IMAGE[link] into an image
    var imgDel = "IMAGE(\\[.*\\]){1}";
    // formats IMAGE[link][size %] into an image
    var imgSizeDel = "IMAGE(\\[.*\\]){2}";

    var re = new RegExp(`(${brDel})|(${boldDel})|(${imgDel})|(${imgSizeDel})|(${linkDel})|(${linkTabDil})`,"gm");
    var match;
    var lastMatchedIndex = 0;
    var keyIndex = 0;
    while ((match = re.exec(data)) != null) {
        formattedText.push(<span key={keyIndex++}>{data.substring(lastMatchedIndex, match.index)}</span>);
        var matchString = match.splice(0)[0];
        if(matchString.match(brDel)){

          // formats <br> tags where there are line breaks
          formattedText.push(<br key={keyIndex++}/>);

        }else if(matchString.match(boldDel)){

          // formats BOLD[content] into an strong tag
          var boldStr = matchString.substring(5, matchString.length - 1);
          formattedText.push(<strong key={keyIndex++}>{boldStr}</strong>);

        }else if(matchString.match(linkDel)){

          // formats LINK[name][link] into an html link
          var linkText = matchString.substring(5, matchString.indexOf("]["));
          var link = matchString.substring(matchString.indexOf("][") + 2, matchString.length - 1);
          formattedText.push(<a key={keyIndex++} href={link}>{linkText}</a>);

        }else if(matchString.match(linkTabDil)){

          // formats LINK_NEW_TAB[name][link] into an html link
          var linkText = matchString.substring(13, matchString.indexOf("]["));
          var link = matchString.substring(matchString.indexOf("][") + 2, matchString.length - 1);
          formattedText.push(<a key={keyIndex++} href={link} target="_blank"  rel="noopener noreferrer">{linkText}</a>);

        }else if(matchString.match(imgSizeDel)){

          // formats IMAGE[link][size %] into an image
          var imageLink = matchString.substring(6, matchString.indexOf("]["));
          var imageSize = matchString.substring(matchString.indexOf("][") + 2, matchString.length - 1);
          console.log(imageSize);
          formattedText.push(<img key={keyIndex++} src={imageLink} style={{width: `${imageSize}%`}}/>);

        }else if(matchString.match(imgDel)){

          // formats IMAGE[link] into an image
          var imageLink = matchString.substring(6, matchString.length - 1);
          formattedText.push(<img key={keyIndex++} src={imageLink} style={{width: "100%"}}/>);

        }else{

          // Default
          formattedText.push(<span key={keyIndex++}>{data.substring(match.index, match.index + matchString.length)}</span>);

        }
        lastMatchedIndex = match.index + matchString.length;
    }
    formattedText.push(<span key={keyIndex++}>{data.substring(lastMatchedIndex, data.length)}</span>);
    return formattedText;
  }

  render() {
    return (
      <div style={{whiteSpace: "pre-line"}}>
        {this.state.text}
      </div>
    );
  }
}
