require 'spec_helper'
require_relative '../../../lib/anystyle/format/ris'

describe AnyStyle::Format::RIS do
  include AnyStyle::Format::RIS

  # Mock of the format_hash method
  def format_hash(dataset)
    dataset
  end

  it 'formats a book reference in RIS format' do
    data = [{
      type: 'book',
      author: [{ family: 'Lingard', given: 'Zac' }],
      issued: '2023',
      title: 'The Great Emu War',
      publisher: 'Wiley',
      ISBN: '9780245839459',
      URL: 'https://example.com',
      edition: '1',
      'publisher-place': 'New York'
    }]

    output = format_ris(data)
    expect(output).to include("TY  - BOOK")
    expect(output).to include("AU  - Lingard, Zac")
    expect(output).to include("TI  - The Great Emu War")
    expect(output).to include("ER  -")
  end
end
