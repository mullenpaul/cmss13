import { useBackend } from '../../backend';
import { Box } from '../../components';
import { MfdPanel, MfdProps } from './MultifunctionDisplay';
import { mfdState } from './stateManagers';
import { CameraProps } from './types';

export const DropshipControlMfdPanel = (props: MfdProps) => {
  const { act } = useBackend();
  const { setPanelState } = mfdState(props.panelStateId);
  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      leftButtons={[
        { children: 'NV-ON', onClick: () => act('nvg-enable') },
        { children: 'NV-OFF', onClick: () => act('nvg-disable') },
      ]}
      bottomButtons={[{ children: 'EXIT', onClick: () => setPanelState('') }]}
    >
      <DropshipControlPanel />
    </MfdPanel>
  );
};

const DropshipControlPanel = () => {
  const { data } = useBackend<CameraProps>();
  return <Box className="NavigationMenu">ff</Box>;
};
