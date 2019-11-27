module LensProtocol
  module OMA
    RSpec.describe Formatter do
      context 'format' do
        it 'generates the OMA formatted string with the Windows line endings' do
          message = Message.from_hash('A' => 1, 'B' => [2, 3])
          expect(subject.format(message)).to eq "A=1\r\nB=2;3\r\n"
        end

        it 'single-value numeric records' do
          message = Message.from_hash('FTYPE' => 3)
          expect(subject.format_lines(message)).to eq %w[FTYPE=3]

          message = Message.from_hash('FTYPE' => nil)
          expect(subject.format_lines(message)).to eq %w[FTYPE=]
        end

        it 'chiral numeric records' do
          message = Message.from_hash('SPH' => [1.251, nil])
          expect(subject.format_lines(message)).to eq %w[SPH=1.25;]
          expect(subject.format_lines(message, types: {'SPH' => Type::Numeric.new(decimals: 1, mode: :chiral)})).to eq %w[SPH=1.3;]
          expect(subject.format_lines(message, types: {'SPH' => Type::Integer.new(mode: :chiral)})).to eq %w[SPH=1;]
        end

        it 'multi-line records' do
          message = Message.from_hash('DRILLE' => [%w[B 1], %w[B 2]])
          expect(subject.format_lines(message)).to eq %w[DRILLE=B;1 DRILLE=B;2]
        end

        context 'tracing datasets' do
          it 'both sides' do
            message = Message.from_hash(
              'TRCFMT' => [
                %w[1 360 E R F],
                %w[1 360 E L F]
              ],
              'R' => [
                [2416, 2410, 2425, 2429],
                [2476, 2478, 2481, 2483]
              ]
            )
            expect(subject.format_lines(message)).to eq %w[
              TRCFMT=1;360;E;R;F
              R=2416;2410;2425;2429
              TRCFMT=1;360;E;L;F
              R=2476;2478;2481;2483
            ]
          end

          it 'only right side' do
            message = Message.from_hash(
              'TRCFMT' => [%w[1 360 E R F], []],
              'R' => [[2416, 2410, 2425, 2429], []]
            )
            expect(subject.format_lines(message)).to eq %w[
              TRCFMT=1;360;E;R;F
              R=2416;2410;2425;2429
            ]
          end

          it 'only left side' do
            message = Message.from_hash(
              'TRCFMT' => [[], %w[1 360 E L F]],
              'R' => [[], [2416, 2410, 2425, 2429]]
            )
            expect(subject.format_lines(message)).to eq %w[
              TRCFMT=1;360;E;L;F
              R=2416;2410;2425;2429
            ]
          end

          it 'should split "R" values into groups of ten' do
            message = OMA.parse <<~OMA
              TRCFMT=1;360;E;R;F
              R=2307;2317;2327;2337;2347;2358;2368;2379;2389;2400
              R=2412;2424;2436;2449;2462;2475;2489;2502;2516;2530
              R=2542;2552;2561;2569;2575;2582;2588;2594;2599;2601
            OMA

            expect(subject.format_lines(message)).to eq %w[
              TRCFMT=1;360;E;R;F
              R=2307;2317;2327;2337;2347;2358;2368;2379;2389;2400
              R=2412;2424;2436;2449;2462;2475;2489;2502;2516;2530
              R=2542;2552;2561;2569;2575;2582;2588;2594;2599;2601
            ]
          end
        end
      end
    end
  end
end
