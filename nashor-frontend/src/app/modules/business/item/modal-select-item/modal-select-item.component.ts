import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Subject, takeUntil } from 'rxjs';
import { ItemService } from '../item.service';
import { Item } from '../item.types';
import { ModalSelectItemService } from './modal-select-item.service';

@Component({
  selector: 'app-modal-select-item',
  templateUrl: './modal-select-item.component.html',
})
export class ModalSelectItemComponent implements OnInit {
  id_item: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  listItem: Item[] = [];
  selectItemForm!: FormGroup;

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _itemService: ItemService,
    private _modalSelectItemService: ModalSelectItemService
  ) {}

  ngOnInit(): void {
    /**
     * get the list of item
     */
    this._itemService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_items: Item[]) => {
        this.listItem = _items;
      });
    /**
     * form
     */
    this.selectItemForm = this._formBuilder.group({
      id_item: ['', [Validators.required]],
    });
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.selectItemForm.patchValue({
      id_item: this.selectItemForm.getRawValue().id_item,
    });
  }
  /**
   * On destroy
   */
  ngOnDestroy(): void {
    /**
     * Unsubscribe from all subscriptions
     */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
  }
  /**
   * changeSelect
   */
  changeSelect(): void {
    this.id_item = this.selectItemForm.getRawValue().id_item;
    this.patchForm();
  }
  /**
   * closeModalSelectItem
   */
  closeModalSelectItem(): void {
    this._modalSelectItemService.closeModalSelectItem();
  }
}
