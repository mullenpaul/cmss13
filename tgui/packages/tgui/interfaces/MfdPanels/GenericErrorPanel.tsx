import { Box } from '../../components';
import { MfdPanel, MfdProps } from './MultifunctionDisplay';
import { mfdState } from './stateManagers';

export const GenericErrorPanel = (props: MfdProps) => {
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
    >
      <Box>Error</Box>
    </MfdPanel>
  );
};
