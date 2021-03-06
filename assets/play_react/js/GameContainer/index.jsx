import React, { Component } from 'react';
import styled from 'styled-components';
import LeftPane from './LeftPane/index.jsx';
import MiddlePane from './MiddlePane/index.jsx';
import RightPane from './RightPane/index.jsx';
import { theme } from '../theme.js';

const FlexRow = styled.div`
  display: flex;
  flex-direction: row;
  height: 800px;
  widht: 100%;
  color: ${theme.text};
  font-family: ${theme.font};
`;

const LeftPaneContainer = styled.div`
  padding: 2em 2em 2em 2em;
  flex: 1;
  background-color: ${theme.bgSecondary};
`;

const MiddlePaneContainer = styled.div`
  display: flex;
  flex: 0 0 768px;
  flex-direction: column;
  height: 800px;
  background-color: ${theme.bgPrimary};
`;

const RightPaneContainer = styled.div`
  padding: 2em 2em 2em 2em;
  flex: 1;
  background-color: ${theme.bgSecondary};
`;

const GameContainer = props => {
  return (
    <FlexRow>
      <LeftPaneContainer>
        <LeftPane />
      </LeftPaneContainer>

      <MiddlePaneContainer>
        <MiddlePane />
      </MiddlePaneContainer>

      <RightPaneContainer>
        <RightPane />
      </RightPaneContainer>
    </FlexRow>
  );
};

export default GameContainer;
