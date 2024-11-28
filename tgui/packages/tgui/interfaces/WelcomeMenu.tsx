import React from 'react';

import { useBackend } from '../backend';
import { Box, Button, Flex } from '../components';
import { Window } from '../layouts';
import { CrtPanel } from './CrtPanel';

interface LobbyData {
  human_name: string;
  xeno_name: string;
  server_time: string;
  round_time: string;
  operation_time: string;
  roundid: string;
  map: string;
  is_ready: 0 | 1;
  is_round_start: 0 | 1;
  loaded: 0 | 1;
  time_remaining: number | string;
}

const Topbar = () => {
  const { data } = useBackend<LobbyData>();
  return (
    <>
      <Flex align="center" grow alignItems="center">
        <Flex.Item grow>{data.human_name ?? 'Unknown'}</Flex.Item>
        <Flex.Item grow style={{ textAlign: 'right' }}>
          {data.operation_time ? `${data.operation_time} Z` : 'Scanning'}
        </Flex.Item>
      </Flex>
      <hr />
    </>
  );
};

const BotBar = () => {
  const { data } = useBackend<LobbyData>();
  return (
    <>
      <hr />
      <Flex align="center" alignItems="center" direction="column">
        <Flex.Item>Weyland Yutani</Flex.Item>
      </Flex>
    </>
  );
};

const PreGameMenu = () => {
  const { act, data } = useBackend<LobbyData>();
  const time_remaining_str =
    typeof data.time_remaining === 'number'
      ? `${data.time_remaining}s`
      : data.time_remaining;
  return (
    <Flex className="MenuContainer" height="100%">
      <Flex direction="column" height="100%" className="Menu">
        <Flex.Item className="PreGameMenuItem">
          <Button onClick={() => act('tutorial')}>Tutorial</Button>
        </Flex.Item>
        <Flex.Item className="PreGameMenuItem">
          <Button onClick={() => act('show_preferences')}>
            Setup Character
          </Button>
        </Flex.Item>
        <Flex.Item className="PreGameMenuItem">
          <Button onClick={() => act('show_playtimes')}>View Playtimes</Button>
        </Flex.Item>
        <Flex.Item className="PreGameMenuItem">
          {data.is_ready === 0 && (
            <Button onClick={() => act('ready')}>Ready</Button>
          )}
          {data.is_ready === 1 && (
            <Button onClick={() => act('unready')}>Not Ready</Button>
          )}
        </Flex.Item>
        <Flex.Item className="PreGameMenuItem">
          <Button onClick={() => act('observe')}>Observe</Button>
        </Flex.Item>
      </Flex>
      <Flex.Item>
        <Flex direction="column" height="100%" className="Menu">
          <Flex.Item>
            <h3>Status... Cryosleep</h3>
          </Flex.Item>
          <Flex.Item>Destination:</Flex.Item>
          <Flex.Item>
            <h3>{data.map}</h3>
          </Flex.Item>
          <Flex.Item>ETA: {time_remaining_str}</Flex.Item>
        </Flex>
      </Flex.Item>
    </Flex>
  );
};

const PostGameMenu = () => {
  const { act, data } = useBackend<LobbyData>();
  return (
    <Flex className="MenuContainer" height="100%">
      <Flex.Item>
        <Flex direction="column" height="100%" className="Menu">
          <Flex.Item>
            <Button onClick={() => act('tutorial')}>Tutorial</Button>
          </Flex.Item>
          <Flex.Item>
            <Button onClick={() => act('show_preferences')}>
              Setup Character
            </Button>
          </Flex.Item>
          <Flex.Item>
            <Button onClick={() => act('show_playtimes')}>
              View Playtimes
            </Button>
          </Flex.Item>
          <Flex.Item>
            <Button onClick={() => act('manifest')}>View Crew Manifest</Button>
          </Flex.Item>
          <Flex.Item>
            <Button onClick={() => act('hiveleaders')}>
              View Hive Leaders
            </Button>
          </Flex.Item>
          <Flex.Item>
            <Button onClick={() => act('late_join')}>Join the USCM!</Button>
          </Flex.Item>
          <Flex.Item>
            <Button onClick={() => act('late_join_xeno')}>
              Join the Hive!
            </Button>
          </Flex.Item>
          <Flex.Item>
            <Button onClick={() => act('late_join_pred')}>
              Join the Hunt!
            </Button>
          </Flex.Item>
          <Flex.Item>
            <Button onClick={() => act('observe')}>Observe</Button>
          </Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item>
        <Flex direction="column" height="100%" className="Menu">
          <Flex.Item>
            <h3>USSAlmayer</h3>
          </Flex.Item>
          <Flex.Item>In orbit above</Flex.Item>
          <Flex.Item>
            <h3>{data.map}</h3>
          </Flex.Item>
          <Flex.Item>Round time: {data.round_time}</Flex.Item>
        </Flex>
      </Flex.Item>
    </Flex>
  );
};

const MenuContent = () => {
  const { data } = useBackend<LobbyData>();
  if (data.is_round_start === 1) {
    return <PreGameMenu />;
  }
  return <PostGameMenu />;
};

const LoadingPage = () => {
  return (
    <Flex
      direction="column"
      justify="space-between"
      className="Test"
      height="400px"
    >
      <Flex.Item className="Topbar">
        <Topbar />
      </Flex.Item>
      <Flex.Item>Loading</Flex.Item>
      <Flex.Item className="Topbar">
        <BotBar />
      </Flex.Item>
    </Flex>
  );
};

const WelcomePage = () => {
  return (
    <Flex direction="column" justify="space-between" height="400px">
      <Flex.Item className="Topbar">
        <Topbar />
      </Flex.Item>
      <Flex.Item grow>
        <MenuContent />
      </Flex.Item>
      <Flex.Item className="Topbar">
        <BotBar />
      </Flex.Item>
    </Flex>
  );
};

export const WelcomeMenu = () => {
  const { data } = useBackend<LobbyData>();
  const crt_color = data.is_round_start && data.is_ready ? 'yellow' : 'blue';
  return (
    <Window width={500} height={500}>
      <Window.Content>
        <Box className="WeaponsConsoleBackground">
          <CrtPanel color={crt_color} className="WelcomeCrt">
            {data.loaded === 1 ? <WelcomePage /> : <LoadingPage />}
          </CrtPanel>
        </Box>
      </Window.Content>
    </Window>
  );
};
