import { useBackend } from "../backend";
import { Button } from "../components";
import { Window } from "../layouts";

const ButtonColor = called => {
  if (called) {
    return "green";
  }
  return "gray";
};

export const Elevator = (_, context) => {
  const { act, data } = useBackend(context);
  const {
    buttons,
  } = data;

  return (
    <Window
      width={420}
      height={180}>
      <Window.Content>
        {
          buttons.map(button => (
            <Button
              key={button.id}
              disabled={button.disabled}
              color={ButtonColor(button.called)}
              width={"130px"}
              lineHeight={1.75}
              content={button.title || button.id}
              onClick={() => act("click", {
                id: button.id,
              })}
            />
          ))
        }
      </Window.Content>
    </Window>
  );
};
