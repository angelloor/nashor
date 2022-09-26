import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Subject, takeUntil } from 'rxjs';
import { PluginItemService } from '../plugin-item.service';
import { PluginItem } from '../plugin-item.types';
import { ModalSelectPluginItemService } from './modal-select-plugin-item.service';

@Component({
  selector: 'app-modal-select-plugin-item',
  templateUrl: './modal-select-plugin-item.component.html',
})
export class ModalSelectPluginItemComponent implements OnInit {
  id_plugin_item: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  listPluginItem: PluginItem[] = [];
  selectPluginItemForm!: FormGroup;

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _pluginItemService: PluginItemService,
    private _modalSelectPluginItemService: ModalSelectPluginItemService
  ) {}

  ngOnInit(): void {
    /**
     * get the list of pluginItem
     */
    this._pluginItemService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_pluginItems: PluginItem[]) => {
        this.listPluginItem = _pluginItems;
      });
    /**
     * form
     */
    this.selectPluginItemForm = this._formBuilder.group({
      id_plugin_item: ['', [Validators.required]],
    });
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.selectPluginItemForm.patchValue({
      id_plugin_item: this.selectPluginItemForm.getRawValue().id_plugin_item,
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
    this.id_plugin_item =
      this.selectPluginItemForm.getRawValue().id_plugin_item;
    this.patchForm();
  }
  /**
   * closeModalSelectPluginItem
   */
  closeModalSelectPluginItem(): void {
    this._modalSelectPluginItemService.closeModalSelectPluginItem();
  }
}
