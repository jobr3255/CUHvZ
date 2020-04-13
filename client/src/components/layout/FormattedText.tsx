import React from "react";

/**
 * FormattedText properties
 */
interface FormattedTextProps {
  text: string
}

/**
 * FormattedText state variables
 */
interface FormattedTextState {
  text: any[]
}

/**
 * Implments the Interpreter pattern
 * Formats text to be displayed as html. Used to display details from the database
 * Can interpret:
  BOLD[content]
  LINK[name][link]
  LINK_NEW_TAB[name][link]
  IMAGE[link]
  IMAGE[link][size %]
  [LINE]
  [SUPPLY_DROPS]
 */
export default class FormattedText extends React.Component<FormattedTextProps, FormattedTextState> {

  constructor(props: FormattedTextProps) {
    super(props);
    this.state = {
      text: []
     };
  }

  /**
   * Fires when component loads on page
   */
  componentDidMount() {
    var formattedText = this.formatData(this.props.text);
    this.setState({
      text: formattedText
    });
  }

  /**
   * formats string into a list of html components
   */
  formatData(data: string): any[] {
    var formattedText = [];
    // formats <br> tags where there are line breaks
    var brDel = "(^\n)";
    // formats BOLD[content] into an strong tag
    var boldDel = "(BOLD\\[.*\\])";
    // formats LINK[name][link] into an html link
    var linkDel = "(LINK\\[.*?().*?\\]\\[.*?().*?\\])";
    // formats LINK_NEW_TAB[name][link] into an html link
    var linkTabDil = "(LINK_NEW_TAB\\[.*?().*?\\]\\[.*?().*?\\])";
    // formats IMAGE[link] into an image
    var imgDel = "(IMAGE(\\[.*\\]){1})";
    // formats IMAGE[link][size %] into an image
    var imgSizeDel = "(IMAGE\\[.*?().*?\\]\\[.*?().*?\\])";
    // formats [LINE] into an hr tag
    var lineDel = "(\\[LINE\\])";
    // formats [SUPPLY_DROPS] into a header
    var supplyDel = "(\\[SUPPLY_DROPS\\])";

    var re = new RegExp(`${brDel}|${boldDel}|${imgSizeDel}|${imgDel}|${linkDel}|${linkTabDil}|${lineDel}|${supplyDel}`,"gm");
    var match, link, linkText, imageLink;
    var lastMatchedIndex = 0;
    var keyIndex = 0;
    while ((match = re.exec(data)) != null) {
        var tmpTxt = data.substring(lastMatchedIndex, match.index);
        if(tmpTxt.trim())
          formattedText.push(<span key={keyIndex++}>{tmpTxt}</span>);
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
          linkText = matchString.substring(5, matchString.indexOf("]["));
          link = matchString.substring(matchString.indexOf("][") + 2, matchString.length - 1);
          formattedText.push(<a key={keyIndex++} href={link}>{linkText}</a>);

        }else if(matchString.match(linkTabDil)){

          // formats LINK_NEW_TAB[name][link] into an html link
          linkText = matchString.substring(13, matchString.indexOf("]["));
          link = matchString.substring(matchString.indexOf("][") + 2, matchString.length - 1);
          formattedText.push(<a key={keyIndex++} href={link} target="_blank"  rel="noopener noreferrer">{linkText}</a>);

        }else if(matchString.match(imgSizeDel)){

          // formats IMAGE[link][size %] into an image
          imageLink = matchString.substring(6, matchString.indexOf("]["));
          var imageSize = matchString.substring(matchString.indexOf("][") + 2, matchString.indexOf("]"));
          formattedText.push(<img key={keyIndex++} src={imageLink} style={{width: `${imageSize}%`}} alt={imageLink}/>);

        }else if(matchString.match(imgDel)){

          // formats IMAGE[link] into an image
          imageLink = matchString.substring(6, matchString.length - 1);
          formattedText.push(<img key={keyIndex++} src={imageLink} style={{width: "100%"}} alt={imageLink}/>);

        }else if(matchString.match(lineDel)){

          // formats [LINE] into an hr tag
          formattedText.push(<hr key={keyIndex++}/>);

        }else if(matchString.match(supplyDel)){

          // formats [SUPPLY_DROPS] into a header
          formattedText.push(<h5 key={keyIndex++} style={{margin: 0}}>Supply Drops</h5>);

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
