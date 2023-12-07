<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ChatChannel extends Model
{
    protected $table = 'chat_channels';

    protected $fillable = [
        'bid_item_id',
        // other fields
    ];

    public function bidItem(): BelongsTo
    {
        return $this->belongsTo(BidItem::class, 'bid_item_id');
    }

    public function chatMessages(): HasMany
    {
        return $this->hasMany(ChatMessage::class, 'chat_channel_id');
    }

    // other model methods
}
