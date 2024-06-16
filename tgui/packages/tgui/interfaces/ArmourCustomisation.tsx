import { useBackend } from '../backend';
import { Button } from '../components';
import { Window } from '../layouts';

export const ArmourCustomisation = () => {
  const { act, data } = useBackend();
  return (
    <Window title="Create Adminhelp" theme="admin" height={300} width={500}>
      <Window.Content
        style={{
          backgroundImage: 'none',
        }}
      >
        <Button onClick={() => act('add_light')}>add light</Button>
        <Button onClick={() => act('remove_light')}>remove light</Button>
        <Button onClick={() => act('big_storage')}>big_storage</Button>
        <Button onClick={() => act('small_storage')}>small_storage</Button>
        <Button onClick={() => act('toggle_light')}>toggle_light</Button>
        <Button onClick={() => act('remove_armor_plate')}>
          remove_armor_plate
        </Button>
      </Window.Content>
    </Window>
  );
};
