import { useBackend } from '../backend';
import { Section, Slider } from '../components';
import { Window } from '../layouts';

export const DragonCoreControl = (props, context) => {
  const { act, data } = useBackend(context);
  if (data.reactor) {
    return (
      <Window resizable theme="weyland" width={300} height={700}>
        <Window.Content>
          <Section title="Inner Core System Management:">
            Shield Power:
            <br />
            <Slider
              value={data.shield_projection}
              fillValue={data.shield_projection}
              minValue={0}
              maxValue={data.max_shield_power}
              step={0.1}
              stepPixelSize={1}
              onDrag={(e, value) =>
                act('input', {
                  amount: value,
                  var: 'shield_projection',
                })
              }
            />
            Magnits Power:
            <br />
            <Slider
              value={data.magnet_impulsion}
              fillValue={data.magnet_impulsion}
              minValue={0}
              maxValue={data.max_magnet_impulsion}
              step={0.1}
              stepPixelSize={1}
              onDrag={(e, value) =>
                act('input', {
                  amount: value,
                  var: 'magnet_impulsion',
                })
              }
            />
            Compression Power:
            <br />
            <Slider
              value={data.compression}
              fillValue={data.compression}
              minValue={0}
              maxValue={data.max_compression}
              step={0.1}
              stepPixelSize={1}
              onDrag={(e, value) =>
                act('input', {
                  amount: value,
                  var: 'compression',
                })
              }
            />
          </Section>
          <Section title="Fuel System Management:">
            Fuel Injection:
            <br />
            <Slider
              value={data.fuel_injection}
              fillValue={data.fuel_injection}
              minValue={0}
              maxValue={data.max_fuel_injection}
              step={0.1}
              stepPixelSize={1}
              onDrag={(e, value) =>
                act('input', {
                  amount: value,
                  var: 'fuel_injection',
                })
              }
            />
            Coolant Injection:
            <br />
            <Slider
              value={data.coolant_injection}
              fillValue={data.coolant_injection}
              minValue={0}
              maxValue={data.max_coolant_injection}
              step={0.1}
              stepPixelSize={1}
              onDrag={(e, value) =>
                act('input', {
                  amount: value,
                  var: 'coolant_injection',
                })
              }
            />
            Ejection:
            <br />
            <Slider
              value={data.contained_ejection}
              fillValue={data.contained_ejection}
              minValue={0}
              maxValue={data.max_contained_ejection}
              step={0.1}
              stepPixelSize={1}
              onDrag={(e, value) =>
                act('input', {
                  amount: value,
                  var: 'contained_ejection',
                })
              }
            />
          </Section>
          <Section title="Outer Core System Management:">
            Heating:
            <br />
            <Slider
              value={data.heating_rate}
              fillValue={data.heating_rate}
              minValue={0}
              maxValue={data.max_heating_rate}
              step={0.1}
              stepPixelSize={1}
              onDrag={(e, value) =>
                act('input', {
                  amount: value,
                  var: 'heating_rate',
                })
              }
            />
            Energy Absorbtion:
            <br />
            <Slider
              value={data.energy_absorbtion_rate}
              fillValue={data.energy_absorbtion_rate}
              minValue={0}
              maxValue={data.max_energy_absorbtion_rate}
              step={0.1}
              stepPixelSize={1}
              onDrag={(e, value) =>
                act('input', {
                  amount: value,
                  var: 'energy_absorbtion_rate',
                })
              }
            />
            Vessel Cooling:
            <br />
            <Slider
              value={data.reactor_cooling_rate}
              fillValue={data.reactor_cooling_rate}
              minValue={0}
              maxValue={data.max_reactor_cooling_rate}
              step={0.1}
              stepPixelSize={1}
              onDrag={(e, value) =>
                act('input', {
                  amount: value,
                  var: 'reactor_cooling_rate',
                })
              }
            />
          </Section>
        </Window.Content>
      </Window>
    );
  } else {
    return <Window resizable theme="weyland" width={300} height={300} />;
  }
};
