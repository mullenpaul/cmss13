import { Box, Stack } from '../../components';
import { MfdPanel, MfdProps } from './MultifunctionDisplay';
import { mfdState } from './stateManagers';

const FlightPanel = () => {
  return (
    <Stack>
      <Stack.Item>Current Location: USS Alamyer</Stack.Item>
    </Stack>
  );
};

export const FlightMfdPanel = (props: MfdProps) => {
  const { setPanelState } = mfdState(props.panelStateId);

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
      ]}
      leftButtons={[
        { children: 'LAUNCH' },
        {},
        { children: 'TARGET' },
        {},
        { children: 'ABORT' },
      ]}
    >
      <Box className="NavigationMenu">
        <FlightPanel />
      </Box>
    </MfdPanel>
  );
};
